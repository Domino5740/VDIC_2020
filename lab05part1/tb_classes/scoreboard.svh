class scoreboard extends uvm_subscriber #(result_transaction);
	`uvm_component_utils(scoreboard)
	
	uvm_tlm_analysis_fifo #(random_command) cmd_f;
	
	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction : new
	
	function void build_phase(uvm_phase phase);
		cmd_f = new("cmd_f", this);
	endfunction : build_phase
	
	function void write(result_transaction t);
		
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
		
		random_command cmd;

		if(cmd_f.try_get(cmd)) begin
			
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
			
			received_C_data = t.C_data;
			received_alu_flags = t.alu_flags;
			received_3b_CRC = t.rec_3b_CRC;
			received_err_flags = t.err_flags;
			received_parity_bit = t.parity_bit;
			
			if(expected_err_flags != 0 && (received_err_flags != expected_err_flags || received_parity_bit != expected_parity_bit)) fail = 1;
			else if((received_alu_flags != expected_alu_flags) || received_C_data != expected_C_data || received_3b_CRC != expected_3b_CRC) fail = 1;
			
			if(fail) $error("FAILED: A: %0h B : %0h op: %s C: %0h", A_data, B_data, opcode.name(), received_C_data);
		end
	endfunction : write

endclass : scoreboard