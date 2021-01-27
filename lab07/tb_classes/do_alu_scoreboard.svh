/******************************************************************************
* DVT CODE TEMPLATE: scoreboard
* Created by dorlowski on Jan 26, 2021
* uvc_company = do, uvc_name = alu
*******************************************************************************/

`ifndef IFNDEF_GUARD_do_alu_scoreboard
`define IFNDEF_GUARD_do_alu_scoreboard

//------------------------------------------------------------------------------
//
// CLASS: do_alu_scoreboard
//
//------------------------------------------------------------------------------
class do_alu_scoreboard extends uvm_component;
	`uvm_component_utils(do_alu_scoreboard)
	
	protected do_alu_result_item m_received_result_item;
	
	// Using suffix to handle more ports
	`uvm_analysis_imp_decl(_collected_item)

	// Connection to the monitor
	uvm_analysis_imp_collected_item#(do_alu_result_item, do_alu_scoreboard) m_monitor_port;
	
	uvm_tlm_analysis_fifo #(do_alu_item) seq_f;
	
	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction : new
	
	function void build_phase(uvm_phase phase);
		seq_f = new("seq_f", this);
		m_monitor_port = new("m_monitor_port",this);
	endfunction : build_phase
	
	function void write_collected_item(do_alu_result_item result_item);
		
		bit signed [31:0] A_data, B_data;
		opcode_t opcode;
		
		bit [3:0] sent_4b_CRC;
		bit [3:0] calculated_4b_CRC;
		
		bit signed [31:0] expected_C_data;
		bit signed [31:0] received_C_data;
		bit [2:0]  expected_3b_CRC;
		bit [2:0]  received_3b_CRC;
		bit [3:0] expected_alu_flags; // CARRY, OVERFLOW, ZERO, NEGATIVE
		bit [3:0] received_alu_flags; // CARRY, OVERFLOW, ZERO, NEGATIVE
	
		bit [5:0] expected_err_flags; //ERR_DATA, ERR_CRC, ERR_OP [*2]
		bit [5:0] received_err_flags; //ERR_DATA, ERR_CRC, ERR_OP [*2]
		bit expected_parity_bit;
		bit received_parity_bit;
		
		bit data_error;
		bit carry;
		bit fail;
		
		do_alu_item cmd;
		m_received_result_item = result_item;
		
		if(seq_f.try_get(cmd)) begin
			
			`uvm_info(get_full_name(), $sformatf("Item collected :\n%s", cmd.sprint()), UVM_HIGH)
			`uvm_info(get_full_name(), $sformatf("Item collected :\n%s", m_received_result_item.sprint()), UVM_HIGH)
			
			carry = 0;
			expected_alu_flags = 0;
			expected_parity_bit = 0;
			
			A_data = cmd.A_data;
			B_data = cmd.B_data;
			sent_4b_CRC  = cmd.sent_4b_CRC;
			opcode = cmd.opcode;
			data_error = cmd.data_error;
			
			if(data_error) expected_err_flags = 6'b100100;
			else begin
				calculated_4b_CRC = calc_crc_4b({B_data, A_data, 1'b1, opcode});
				if(sent_4b_CRC != calculated_4b_CRC) expected_err_flags = 6'b010010;
				else expected_err_flags = 6'b000000;
				case(opcode)
					and_opcode: begin
						expected_C_data = B_data & A_data;
					end
					add_opcode: begin
						{carry, expected_C_data} = $unsigned(B_data) + $unsigned(A_data);
						if((A_data >= 0) & (B_data >= 0) & (expected_C_data < 0)) expected_alu_flags[2] = 1;
						else if ((A_data < 0) & (B_data < 0) & (expected_C_data >= 0)) expected_alu_flags[2] = 1;
						else expected_alu_flags[2] = 0;
					end
					or_opcode: begin
						expected_C_data = B_data | A_data;
					end
					sub_opcode: begin
						{carry, expected_C_data} = $unsigned(B_data) - $unsigned(A_data);
						if((A_data < 0) & (B_data >= 0) & (expected_C_data < 0)) expected_alu_flags[2] = 1;
						else if ((A_data >= 0) & (B_data < 0) & (expected_C_data >= 0)) expected_alu_flags[2] = 1;
						else expected_alu_flags[2] = 0;
					end
					default: begin
						expected_err_flags = 6'b001001;
					end
				endcase
				if(opcode != no_opcode) begin
					expected_alu_flags[3] = carry;
					expected_alu_flags[1] = (expected_C_data == 0); 
					expected_alu_flags[0] = (expected_C_data <  0);
					expected_3b_CRC = calc_crc_3b({expected_C_data, 1'b0, expected_alu_flags}); //same as above
				end
			end
			
			if(expected_err_flags != 0) begin
				expected_parity_bit = ^{1'b1, expected_err_flags};
				expected_alu_flags = 0;
				expected_C_data = 0;
				expected_3b_CRC = 0;
			end
			
			received_C_data = m_received_result_item.C_data;
			received_alu_flags = m_received_result_item.alu_flags;
			received_3b_CRC = m_received_result_item.rec_3b_CRC;
			received_err_flags = m_received_result_item.err_flags;
			received_parity_bit = m_received_result_item.parity_bit;
			
			if(expected_err_flags != 0 && (received_err_flags != expected_err_flags || received_parity_bit != expected_parity_bit)) fail = 1;
			else if((received_alu_flags != expected_alu_flags) || received_C_data != expected_C_data || received_3b_CRC != expected_3b_CRC) fail = 1;
			
			if(fail) $error("FAILED: A: %0h B : %0h op: %s C: %0h", A_data, B_data, opcode.name(), received_C_data);
		end
	endfunction : write_collected_item

endclass : do_alu_scoreboard

`endif // IFNDEF_GUARD_do_alu_scoreboard
