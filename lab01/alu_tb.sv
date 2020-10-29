`timescale 1ns/1ps
module top_TB;

typedef enum bit[2:0] {
	no_op		= 3'b000,
	and_op		= 3'b001,
	or_op 		= 3'b010,
	add_op 		= 3'b011,
	sub_op 		= 3'b100,
	rst_op 		= 3'b101,
	bad_data_op = 3'b110,
	bad_crc_op 	= 3'b111
} operation_t;

typedef enum bit[2:0] {
	and_opcode		= 3'b000,
	or_opcode 		= 3'b001,
	add_opcode 		= 3'b100,
	sub_opcode 		= 3'b101
} opcode_t;
	
	
typedef enum bit [1:0] {
	DATA = 2'b00,
	CTL = 2'b10,
	ERR = 2'b11
} byte_type_t;

operation_t op_set;

bit clk, rst_n;
bit sin = 1;
bit sout;
	
bit [31:0] A_data, B_data;
bit [3:0] crc_4b;

mtm_Alu DUT (.clk, .rst_n, .sin, .sout);

initial begin
	clk = 0;
	forever #10 clk = ~clk;
end

covergroup op_cov;
	option.name = "cg_op_cov";
	coverpoint op_set {
		bins A1_all_op[] = {[and_op:sub_op]};
		bins A2_rst_to_op[] = (rst_op => [and_op : sub_op]);
		bins A3_op_to_rst[] = ([and_op:sub_op] => rst_op);
		bins A4_twoops[] = ([and_op:sub_op] [* 2]);
		bins A5_bad_data = bad_data_op;
		bins A6a_bad_crc = bad_crc_op;
		bins A7_no_op = no_op;
	}
endgroup

covergroup zeros_or_ones_on_ops;
	option.name = "cg_zeros_or_ones_on_ops";
	
	all_ops : coverpoint op_set {
		ignore_bins null_ops = {rst_op, no_op, bad_data_op, bad_crc_op};
	}
	a_leg: coverpoint A_data {
		bins zeros  = {'h00000000};
		bins others = {['h00000001:'hFFFFFFFE]};
		bins ones   = {'hFFFFFFFF};
	}
	b_leg: coverpoint B_data {
		bins zeros  = {'h00000000};
		bins others = {['h00000001:'hFFFFFFFE]};
		bins ones   = {'hFFFFFFFF};
	}
	B_op_00_FF: cross a_leg, b_leg, all_ops {
	// #B1 simulate all zero input for all the operations
		bins B1_add_00 = binsof (all_ops) intersect {add_op} &&
						(binsof (a_leg.zeros) || binsof (b_leg.zeros));
		bins B1_and_00 = binsof (all_ops) intersect {and_op} &&
						(binsof (a_leg.zeros) || binsof (b_leg.zeros));
	ignore_bins others_only = binsof(a_leg.others) && binsof(b_leg.others);
	}
endgroup

op_cov oc;
zeros_or_ones_on_ops c_00_FF;

initial begin : coverage
	oc = new();
	c_00_FF = new();
	forever begin @(negedge clk);
		oc.sample();
		c_00_FF.sample();
	end
end : coverage


function operation_t get_op();
	bit[2:0] op_choice;
	op_choice = $random;
	case(op_choice)
		3'b000	:	return and_op;
		3'b001	:	return or_op;
		3'b010	:	return add_op;
		3'b011	:	return sub_op;
		3'b100  :	return no_op;
		3'b101  :	return rst_op;
		3'b110  :	return bad_data_op;
		3'b111  :	return bad_crc_op;
	endcase
endfunction

function opcode_t get_opcode();
	bit[1:0] opcode_choice;
	opcode_choice = $random;
	case(opcode_choice)
		2'b00	:	return and_opcode;
		2'b01	:	return add_opcode;
		2'b10	:	return or_opcode;
		2'b11	:	return sub_opcode;
	endcase
endfunction

function bit [2:0] get_noopcode();
	bit[1:0] opcode_choice;
	opcode_choice = $random;
	case(opcode_choice)
		2'b00	:	return 3'b010;
		2'b01	:	return 3'b011;
		2'b10	:	return 3'b110;
		2'b11	:	return 3'b111;
	endcase
endfunction

function [31:0] get_data();
	bit [1:0] zero_ones;
	zero_ones = $random;
	if(zero_ones == 2'b00)
		return 32'h00000000;
	else if(zero_ones == 2'b11)
		return 32'hFFFFFFFF;
	else
		return $random();
endfunction

function bit [2:0] calc_crc_3b(input [36:0] data_in);

  	static bit [2:0] lfsr_q = 3'b111;
	bit [2:0] crc_out;

	crc_out[0] = lfsr_q[1] ^ data_in[0] ^ data_in[2] ^ data_in[3] ^ data_in[4] ^ data_in[7] ^ data_in[9] ^ data_in[10] ^ data_in[11] ^ data_in[14] ^ data_in[16] ^ data_in[17] ^ data_in[18] ^ data_in[21] ^ data_in[23] ^ data_in[24] ^ data_in[25] ^ data_in[28] ^ data_in[30] ^ data_in[31] ^ data_in[32] ^ data_in[35];
    crc_out[1] = lfsr_q[1] ^ lfsr_q[2] ^ data_in[0] ^ data_in[1] ^ data_in[2] ^ data_in[5] ^ data_in[7] ^ data_in[8] ^ data_in[9] ^ data_in[12] ^ data_in[14] ^ data_in[15] ^ data_in[16] ^ data_in[19] ^ data_in[21] ^ data_in[22] ^ data_in[23] ^ data_in[26] ^ data_in[28] ^ data_in[29] ^ data_in[30] ^ data_in[33] ^ data_in[35] ^ data_in[36];
    crc_out[2] = lfsr_q[0] ^ lfsr_q[2] ^ data_in[1] ^ data_in[2] ^ data_in[3] ^ data_in[6] ^ data_in[8] ^ data_in[9] ^ data_in[10] ^ data_in[13] ^ data_in[15] ^ data_in[16] ^ data_in[17] ^ data_in[20] ^ data_in[22] ^ data_in[23] ^ data_in[24] ^ data_in[27] ^ data_in[29] ^ data_in[30] ^ data_in[31] ^ data_in[34] ^ data_in[36];
    
	return crc_out;
	
endfunction

function bit [3:0] calc_crc_4b(input [67:0] data_in);

  	static bit [3:0] lfsr_q = 4'b0000;
	bit [3:0] crc_out;

    crc_out[0] = lfsr_q[0] ^ lfsr_q[2] ^ data_in[0] ^ data_in[3] ^ data_in[4] ^ data_in[6] ^ data_in[8] ^ data_in[9] ^ data_in[10] ^ data_in[11] ^ data_in[15] ^ data_in[18] ^ data_in[19] ^ data_in[21] ^ data_in[23] ^ data_in[24] ^ data_in[25] ^ data_in[26] ^ data_in[30] ^ data_in[33] ^ data_in[34] ^ data_in[36] ^ data_in[38] ^ data_in[39] ^ data_in[40] ^ data_in[41] ^ data_in[45] ^ data_in[48] ^ data_in[49] ^ data_in[51] ^ data_in[53] ^ data_in[54] ^ data_in[55] ^ data_in[56] ^ data_in[60] ^ data_in[63] ^ data_in[64] ^ data_in[66];
    crc_out[1] = lfsr_q[1] ^ lfsr_q[2] ^ lfsr_q[3] ^ data_in[0] ^ data_in[1] ^ data_in[3] ^ data_in[5] ^ data_in[6] ^ data_in[7] ^ data_in[8] ^ data_in[12] ^ data_in[15] ^ data_in[16] ^ data_in[18] ^ data_in[20] ^ data_in[21] ^ data_in[22] ^ data_in[23] ^ data_in[27] ^ data_in[30] ^ data_in[31] ^ data_in[33] ^ data_in[35] ^ data_in[36] ^ data_in[37] ^ data_in[38] ^ data_in[42] ^ data_in[45] ^ data_in[46] ^ data_in[48] ^ data_in[50] ^ data_in[51] ^ data_in[52] ^ data_in[53] ^ data_in[57] ^ data_in[60] ^ data_in[61] ^ data_in[63] ^ data_in[65] ^ data_in[66] ^ data_in[67];
    crc_out[2] = lfsr_q[0] ^ lfsr_q[2] ^ lfsr_q[3] ^ data_in[1] ^ data_in[2] ^ data_in[4] ^ data_in[6] ^ data_in[7] ^ data_in[8] ^ data_in[9] ^ data_in[13] ^ data_in[16] ^ data_in[17] ^ data_in[19] ^ data_in[21] ^ data_in[22] ^ data_in[23] ^ data_in[24] ^ data_in[28] ^ data_in[31] ^ data_in[32] ^ data_in[34] ^ data_in[36] ^ data_in[37] ^ data_in[38] ^ data_in[39] ^ data_in[43] ^ data_in[46] ^ data_in[47] ^ data_in[49] ^ data_in[51] ^ data_in[52] ^ data_in[53] ^ data_in[54] ^ data_in[58] ^ data_in[61] ^ data_in[62] ^ data_in[64] ^ data_in[66] ^ data_in[67];
    crc_out[3] = lfsr_q[1] ^ lfsr_q[3] ^ data_in[2] ^ data_in[3] ^ data_in[5] ^ data_in[7] ^ data_in[8] ^ data_in[9] ^ data_in[10] ^ data_in[14] ^ data_in[17] ^ data_in[18] ^ data_in[20] ^ data_in[22] ^ data_in[23] ^ data_in[24] ^ data_in[25] ^ data_in[29] ^ data_in[32] ^ data_in[33] ^ data_in[35] ^ data_in[37] ^ data_in[38] ^ data_in[39] ^ data_in[40] ^ data_in[44] ^ data_in[47] ^ data_in[48] ^ data_in[50] ^ data_in[52] ^ data_in[53] ^ data_in[54] ^ data_in[55] ^ data_in[59] ^ data_in[62] ^ data_in[63] ^ data_in[65] ^ data_in[67];

	return crc_out;
	
endfunction

task send_byte(input bit [10:0] data);
	for(int i = 10; i >= 0; i--) begin
		@(negedge clk) sin = data[i];
	end
endtask

task send_data_byte(input bit [7:0] data);
	send_byte({2'b00, data, 1'b1});
endtask

task send_ctl_byte(input bit [7:0] data);
	send_byte({2'b01, data, 1'b1});
endtask

task send_data(input bit [31:0] data);
	send_data_byte(data[31 : 24]);
	send_data_byte(data[23 : 16]);
	send_data_byte(data[15 : 8]);
	send_data_byte(data[7  : 0]);
endtask

task read_byte_sin(
	output byte_type_t bt,
	output bit [7:0] data_out,
	output bit [3:0] crc,
	output operation_t op);
		
	while(sin != 0) @(negedge clk);
	
	@(negedge clk)
		if(sin == 0) begin : read_data_byte
			bt = DATA;
			for(int i = 7; i >= 0; i--) begin
				@(negedge clk) data_out[i] = sin;
			end
		end : read_data_byte
		else begin: read_ctl_byte
			@(negedge clk);
			if(sin == 0) bt = CTL;
			else bt = ERR;
			@(negedge clk);
			for(int i = 3; i >= 0; i--) begin
				@(negedge clk) op[i] = sin;
			end
			for(int i = 4; i >= 0; i--) begin
				@(negedge clk) crc[i] = sin;
			end
		end : read_ctl_byte
		@(negedge clk);
endtask

task read_serial_sin(
		output bit [31:0] A,
		output bit [31:0] B,
		output bit [3:0] crc,
		output operation_t op,
		output bit data_error
	);
	
	bit [7:0] d;
	byte_type_t byte_type;
	
	read_byte_sin(byte_type, d, crc,  op);
	if(byte_type == DATA) B [31 : 24] = d;
	else data_error = 1;
	
	read_byte_sin(byte_type, d, crc,  op);
	if(byte_type == DATA) B [23 : 16] = d;
	else data_error = 1;
	
	read_byte_sin(byte_type, d, crc,  op);
	if(byte_type == DATA) B [15 : 8] = d;
	else data_error = 1;
	
	read_byte_sin(byte_type, d, crc,  op);
	if(byte_type == DATA) B [7 : 0] = d;
	else data_error = 1;
	
	read_byte_sin(byte_type, d, crc,  op);
	if(byte_type == DATA) A [31 : 24] = d;
	else data_error = 1;
	
	read_byte_sin(byte_type, d, crc,  op);
	if(byte_type == DATA) A [23 : 16] = d;
	else data_error = 1;
	
	read_byte_sin(byte_type, d, crc,  op);
	if(byte_type == DATA) A [15 : 8] = d;
	else data_error = 1;
	
	read_byte_sin(byte_type, d, crc,  op);
	if(byte_type == DATA) A [7 : 0] = d;
	else data_error = 1;

	read_byte_sin(byte_type, d, crc, op);
	if(byte_type == CTL) data_error = 0;
	else data_error = 1;
endtask

task read_byte_sout(
	output byte_type_t bt,
	output bit [7:0] data_out,
	output bit [3:0] alu_flags,
	output bit [2:0] crc,
	output bit [5:0] err_flags,
	output bit parity_bit);
		
	while(sout != 0) @(negedge clk);
	
	@(negedge clk)
		if(sout == 0) begin : read_data_byte
			bt = DATA;
			for(int i = 7; i >= 0; i--) begin
				@(negedge clk) data_out[i] = sout;
			end
		end : read_data_byte
		else begin
			@(negedge clk);
			if(sout == 0) begin : read_ctl_byte
				bt = CTL;
				for(int i = 3; i >= 0; i--) begin
					@(negedge clk) alu_flags[i] = sout;
				end
				for(int i = 2; i >= 0; i--) begin
					@(negedge clk) crc[i] = sout;
				end
			end : read_ctl_byte
			else begin : read_err_byte
				bt = ERR;
				for(int i = 5; i >= 0; i--) begin
					@(negedge clk) err_flags[i] = sout;
				end
				@(negedge clk);
				parity_bit = sout;
			end : read_err_byte
		end
		@(negedge clk);
endtask

task read_serial_sout(
	output bit [31:0] C,
	output bit [3:0] alu_flags,
	output bit [2:0] crc,
	output bit [5:0] err_flags,
	output bit parity_bit);
	
	byte_type_t byte_type;
	bit [7:0] d;
		
	read_byte_sout(byte_type, d, alu_flags, crc, err_flags, parity_bit);
	if(byte_type == DATA) C [31 : 24] = d;
	else if(byte_type == ERR) disable read_serial_sout;
	
	read_byte_sout(byte_type, d, alu_flags, crc, err_flags, parity_bit);
	C [23 : 16] = d;
	
	read_byte_sout(byte_type, d, alu_flags, crc, err_flags, parity_bit);
	C [15 : 8] = d;
	
	read_byte_sout(byte_type, d, alu_flags, crc, err_flags, parity_bit);
	C [7 : 0] = d;
		
	read_byte_sout(byte_type, d, alu_flags, crc, err_flags, parity_bit);
endtask

initial begin : tester
	opcode_t opcode_set;
	bit [2:0] noopcode;
	
	rst_n = 1'b0;
	@(negedge clk); @(negedge clk);
	rst_n = 1'b1;
	sin = 1'b1;
	
	repeat(10) begin
		@(negedge clk);
		op_set = get_op();
		A_data = get_data();
		B_data = get_data();
		crc_4b = calc_crc_4b({B_data, A_data, 1'b1, op_set});
		sin = 1'b1;
		@(negedge clk);
		
		send_data(B_data);
		send_data(A_data);
		
		case(op_set)
			rst_op: begin
				rst_n = 0;
				@(negedge clk);
				rst_n = 1;
			end
			bad_data_op: begin
				opcode_set = get_opcode();
				send_data_byte(A_data[0]);
				send_ctl_byte({1'b0, opcode_set, crc_4b});
			end
			bad_crc_op: begin
				crc_4b = $random();
				opcode_set = get_opcode();
				send_ctl_byte({1'b0, opcode_set, crc_4b});
			end
			no_op : begin
				noopcode = get_noopcode();
				send_ctl_byte({1'b0, noopcode, crc_4b});
			end
			and_op: begin
				opcode_set = and_opcode;
				send_ctl_byte({1'b0, opcode_set, crc_4b});
			end
			or_op: begin
				opcode_set = or_opcode;
				send_ctl_byte({1'b0, opcode_set, crc_4b});
			end
			add_op: begin
				opcode_set = add_opcode;
				send_ctl_byte({1'b0, opcode_set, crc_4b});
			end
			sub_op: begin	
				opcode_set = sub_opcode;
				send_ctl_byte({1'b0, opcode_set, crc_4b});
			end
		endcase
		$strobe("%0t %0g", $time, $get_coverage());
	end
	$finish;
end : tester

initial begin : scoreboard
	bit [31:0] A_data, B_data;
	operation_t opcode;
	
	bit [3:0] sent_4b_CRC;
	bit [3:0] calculated_4b_CRC;
	
	bit [31:0] expected_C_data;
	bit [31:0] received_C_data;
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
	bit overflow;
	bit fail;
	forever begin
		A_data = 0;
		B_data = 0;
		sent_4b_CRC = 0;
		opcode[2:0] = 3'b000;
		data_error = 0;
		expected_err_flags = 0;
		carry = 0;
		expected_alu_flags = 0;
		expected_C_data = 0;
		
		read_serial_sin(A_data, B_data, sent_4b_CRC, opcode, data_error);
		if(data_error) expected_err_flags = 6'b100100;
		else begin
			calculated_4b_CRC = calc_crc_4b({B_data, A_data, 1'b1, opcode});
			if(sent_4b_CRC != calculated_4b_CRC) expected_err_flags = 6'b010010;
			else expected_err_flags = 6'b000000;
			case(opcode)
				and_op: begin
					expected_C_data = A_data & B_data;
				end
				add_op: begin
					{carry, expected_C_data} = A_data + B_data;
				end
				or_op: begin
					expected_C_data = A_data | B_data;
				end
				sub_op: begin
					{carry, expected_C_data} = B_data - A_data;
				end
				default: begin
					expected_err_flags = 6'b001001;
				end
			endcase
			expected_alu_flags[3] = carry;
			expected_alu_flags[2] = ({carry, expected_C_data[31]} == 2'b01);
			if(expected_C_data == 0) expected_alu_flags[1] = 1; 
			if(expected_C_data <  0) expected_alu_flags[0] = 1;
			
			expected_3b_CRC = calc_crc_3b({expected_C_data, 1'b0, expected_alu_flags});
		end
		
		if(expected_err_flags != 0) expected_parity_bit = ^{1'b1, expected_err_flags};
		else expected_parity_bit = 0;
		
		read_serial_sout(received_C_data, received_alu_flags, received_3b_CRC, received_err_flags, received_parity_bit);
		//if(expected_err_flags != 0 && (received_err_flags != expected_err_flags || received_parity_bit != expected_parity_bit)) fail = 1;
		//if((received_alu_flags != expected_alu_flags) || received_C_data != expected_C_data || received_3b_CRC != expected_3b_CRC) fail = 1;
		//if(received_C_data != expected_C_data) fail = 1;
		
		//if(fail) $error("FAILED: A: %0h B : %0h op: %s C: %0h", A_data, B_data, opcode.name(), received_C_data);
	end
end : scoreboard

endmodule