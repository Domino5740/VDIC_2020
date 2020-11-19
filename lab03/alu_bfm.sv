`timescale 1ns/1ps
interface alu_bfm;

import alu_pkg::*;

bit clk, rst_n;
bit sin = 1;
bit sout;
	
bit [31:0] A_data, B_data;
tester_op_t tester_op_set;
opcode_t opcode_set;

initial begin
	clk = 0;
	forever #10 clk = ~clk;
end

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

function bit [2:0] calc_crc_3b(input bit [36:0] data_in);

  	static bit [2:0] lfsr_q = 3'b000;
	bit [2:0] crc_out;

	crc_out[0] = lfsr_q[1] ^ data_in[0] ^ data_in[2] ^ data_in[3] ^ data_in[4] ^ data_in[7] ^ data_in[9] ^ data_in[10] ^ data_in[11] ^ data_in[14] ^ data_in[16] ^ data_in[17] ^ data_in[18] ^ data_in[21] ^ data_in[23] ^ data_in[24] ^ data_in[25] ^ data_in[28] ^ data_in[30] ^ data_in[31] ^ data_in[32] ^ data_in[35];
    crc_out[1] = lfsr_q[1] ^ lfsr_q[2] ^ data_in[0] ^ data_in[1] ^ data_in[2] ^ data_in[5] ^ data_in[7] ^ data_in[8] ^ data_in[9] ^ data_in[12] ^ data_in[14] ^ data_in[15] ^ data_in[16] ^ data_in[19] ^ data_in[21] ^ data_in[22] ^ data_in[23] ^ data_in[26] ^ data_in[28] ^ data_in[29] ^ data_in[30] ^ data_in[33] ^ data_in[35] ^ data_in[36];
    crc_out[2] = lfsr_q[0] ^ lfsr_q[2] ^ data_in[1] ^ data_in[2] ^ data_in[3] ^ data_in[6] ^ data_in[8] ^ data_in[9] ^ data_in[10] ^ data_in[13] ^ data_in[15] ^ data_in[16] ^ data_in[17] ^ data_in[20] ^ data_in[22] ^ data_in[23] ^ data_in[24] ^ data_in[27] ^ data_in[29] ^ data_in[30] ^ data_in[31] ^ data_in[34] ^ data_in[36];
    
	return crc_out;
	
endfunction

function bit [3:0] calc_crc_4b(input bit [67:0] data_in);

  	static bit [3:0] lfsr_q = 4'b0000;
	bit [3:0] crc_out;

    crc_out[0] = lfsr_q[0] ^ lfsr_q[2] ^ data_in[0] ^ data_in[3] ^ data_in[4] ^ data_in[6] ^ data_in[8] ^ data_in[9] ^ data_in[10] ^ data_in[11] ^ data_in[15] ^ data_in[18] ^ data_in[19] ^ data_in[21] ^ data_in[23] ^ data_in[24] ^ data_in[25] ^ data_in[26] ^ data_in[30] ^ data_in[33] ^ data_in[34] ^ data_in[36] ^ data_in[38] ^ data_in[39] ^ data_in[40] ^ data_in[41] ^ data_in[45] ^ data_in[48] ^ data_in[49] ^ data_in[51] ^ data_in[53] ^ data_in[54] ^ data_in[55] ^ data_in[56] ^ data_in[60] ^ data_in[63] ^ data_in[64] ^ data_in[66];
    crc_out[1] = lfsr_q[1] ^ lfsr_q[2] ^ lfsr_q[3] ^ data_in[0] ^ data_in[1] ^ data_in[3] ^ data_in[5] ^ data_in[6] ^ data_in[7] ^ data_in[8] ^ data_in[12] ^ data_in[15] ^ data_in[16] ^ data_in[18] ^ data_in[20] ^ data_in[21] ^ data_in[22] ^ data_in[23] ^ data_in[27] ^ data_in[30] ^ data_in[31] ^ data_in[33] ^ data_in[35] ^ data_in[36] ^ data_in[37] ^ data_in[38] ^ data_in[42] ^ data_in[45] ^ data_in[46] ^ data_in[48] ^ data_in[50] ^ data_in[51] ^ data_in[52] ^ data_in[53] ^ data_in[57] ^ data_in[60] ^ data_in[61] ^ data_in[63] ^ data_in[65] ^ data_in[66] ^ data_in[67];
    crc_out[2] = lfsr_q[0] ^ lfsr_q[2] ^ lfsr_q[3] ^ data_in[1] ^ data_in[2] ^ data_in[4] ^ data_in[6] ^ data_in[7] ^ data_in[8] ^ data_in[9] ^ data_in[13] ^ data_in[16] ^ data_in[17] ^ data_in[19] ^ data_in[21] ^ data_in[22] ^ data_in[23] ^ data_in[24] ^ data_in[28] ^ data_in[31] ^ data_in[32] ^ data_in[34] ^ data_in[36] ^ data_in[37] ^ data_in[38] ^ data_in[39] ^ data_in[43] ^ data_in[46] ^ data_in[47] ^ data_in[49] ^ data_in[51] ^ data_in[52] ^ data_in[53] ^ data_in[54] ^ data_in[58] ^ data_in[61] ^ data_in[62] ^ data_in[64] ^ data_in[66] ^ data_in[67];
    crc_out[3] = lfsr_q[1] ^ lfsr_q[3] ^ data_in[2] ^ data_in[3] ^ data_in[5] ^ data_in[7] ^ data_in[8] ^ data_in[9] ^ data_in[10] ^ data_in[14] ^ data_in[17] ^ data_in[18] ^ data_in[20] ^ data_in[22] ^ data_in[23] ^ data_in[24] ^ data_in[25] ^ data_in[29] ^ data_in[32] ^ data_in[33] ^ data_in[35] ^ data_in[37] ^ data_in[38] ^ data_in[39] ^ data_in[40] ^ data_in[44] ^ data_in[47] ^ data_in[48] ^ data_in[50] ^ data_in[52] ^ data_in[53] ^ data_in[54] ^ data_in[55] ^ data_in[59] ^ data_in[62] ^ data_in[63] ^ data_in[65] ^ data_in[67];

	return crc_out;
	
endfunction

task reset_alu();
	rst_n = 1'b0;
	@(negedge clk); @(negedge clk);
	rst_n = 1'b1;
	sin = 1'b1;
	@(negedge clk);
endtask

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

task test_op(input bit [31:0] A, B,
			 input tester_op_t op);

	bit [3:0] crc_4b;

	tester_op_set = op;
	A_data = A;
	B_data = B;

	case(tester_op_set)
		rst_op_test: begin
			rst_n = 0;
			for(int i = 0; i <= 99; i++) @(negedge clk);
			rst_n = 1;
		end
		bad_data_op_test: begin
			opcode_set = get_opcode();
		end
		bad_crc_op_test: begin
			opcode_set = get_opcode();
		end
		no_op_test : begin
			opcode_set = no_opcode;
		end
		and_op_test: begin
			opcode_set = and_opcode;
		end
		or_op_test: begin
			opcode_set = or_opcode;
		end
		add_op_test: begin
			opcode_set = add_opcode;
		end
		sub_op_test: begin	
			opcode_set = sub_opcode;
		end
	endcase
	
	if(tester_op_set != rst_op_test) begin
		send_data(B_data);
		if(tester_op_set == bad_data_op_test) begin
			send_data_byte(A_data[31 : 24]);
			send_data_byte(A_data[23 : 16]);
			send_data_byte(A_data[15 : 8]);
		end
		else begin
			send_data(A_data);
		end
		crc_4b = calc_crc_4b({B_data, A_data, 1'b1, opcode_set});
		crc_4b = (tester_op_set == bad_crc_op_test) ? crc_4b + 1 : crc_4b;
		send_ctl_byte({1'b0, opcode_set, crc_4b});
	end

endtask

task read_byte_sin(
	output byte_type_t bt,
	output bit [7:0] data_out,
	output bit [3:0] crc,
	output opcode_t op);
	
	data_out = 0;
	crc = 0;

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
			for(int i = 2; i >= 0; i--) begin
				@(negedge clk) op[i] = sin;
			end
			for(int i = 3; i >= 0; i--) begin
				@(negedge clk) crc[i] = sin;
			end
		end : read_ctl_byte
		@(negedge clk);
endtask

task read_serial_sin(
		output bit [31:0] A,
		output bit [31:0] B,
		output bit [3:0] crc,
		output opcode_t op,
		output bit data_error
	);
	
	bit [7:0] d;
	byte_type_t byte_type;
	A = 0;
	B = 0;
	
	read_byte_sin(byte_type, d, crc,  op);
	if(byte_type == DATA) B [31 : 24] = d;
	else  begin
		data_error = 1;
		disable read_serial_sin;
	end
	
	read_byte_sin(byte_type, d, crc,  op);
	if(byte_type == DATA) B [23 : 16] = d;
	else  begin
		data_error = 1;
		disable read_serial_sin;
	end
	
	read_byte_sin(byte_type, d, crc,  op);
	if(byte_type == DATA) B [15 : 8] = d;
	else  begin
		data_error = 1;
		disable read_serial_sin;
	end
	
	read_byte_sin(byte_type, d, crc,  op);
	if(byte_type == DATA) B [7 : 0] = d;
	else  begin
		data_error = 1;
		disable read_serial_sin;
	end
	
	read_byte_sin(byte_type, d, crc,  op);
	if(byte_type == DATA) A [31 : 24] = d;
	else  begin
		data_error = 1;
		disable read_serial_sin;
	end
	
	read_byte_sin(byte_type, d, crc,  op);
	if(byte_type == DATA) A [23 : 16] = d;
	else  begin
		data_error = 1;
		disable read_serial_sin;
	end
	
	read_byte_sin(byte_type, d, crc,  op);
	if(byte_type == DATA) A [15 : 8] = d;
	else  begin
		data_error = 1;
		disable read_serial_sin;
	end
	
	read_byte_sin(byte_type, d, crc,  op);
	if(byte_type == DATA) A [7 : 0] = d;
	else  begin
		data_error = 1;
		disable read_serial_sin;
	end
	
	crc = 0;
	
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
	
	data_out = 0;
	alu_flags = 0;
	crc = 0;
	err_flags = 0;
	parity_bit = 0;
		
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
	
	C = 0;
	err_flags = 0;
		
	read_byte_sout(byte_type, d, alu_flags, crc, err_flags, parity_bit);
	if(byte_type == DATA) C [31 : 24] = d;
	else if(byte_type == ERR) disable read_serial_sout;
	
	read_byte_sout(byte_type, d, alu_flags, crc, err_flags, parity_bit);
	C [23 : 16] = d;
	
	read_byte_sout(byte_type, d, alu_flags, crc, err_flags, parity_bit);
	C [15 : 8] = d;
	
	read_byte_sout(byte_type, d, alu_flags, crc, err_flags, parity_bit);
	C [7 : 0] = d;
	
	alu_flags = 0;
	crc = 0;
		
	read_byte_sout(byte_type, d, alu_flags, crc, err_flags, parity_bit);
endtask

endinterface