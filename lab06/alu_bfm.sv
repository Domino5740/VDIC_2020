`timescale 1ns/1ps
interface alu_bfm;

import alu_pkg::*;

bit clk, rst_n;
bit sin = 1;
bit sout;
	
bit [31:0] A_data, B_data;
tester_op_t tester_op_set;
opcode_t opcode_set;

bit result_read, new_data;

initial begin : clock_gen
	clk = 0;
	forever #10 clk = ~clk;
end : clock_gen

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
			 input tester_op_t op, input opcode_t opcode);

	bit [3:0] crc_4b;

	tester_op_set = op;
	opcode_set = opcode;
	A_data = A;
	B_data = B;
	new_data = 1;
	
	case(tester_op_set)
		rst_op_test: begin
			reset_alu();
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
		default: begin
			opcode_set = opcode;
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
	new_data = 0;
	#1500;
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
	
	wait(result_read);
	
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
	result_read = 0;
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
	result_read = 1;
	@(negedge clk);
endtask

command_monitor command_monitor_h;
sequence_item seq_item;

initial begin : command_monitor_thread
	seq_item = new("seq_item");
	forever begin
		
		wait(new_data);
		seq_item.tester_op = tester_op_set;
		read_serial_sin(seq_item.A_data, seq_item.B_data, seq_item.sent_4b_CRC, seq_item.opcode, seq_item.data_error);
		command_monitor_h.write_to_monitor(seq_item);
	end
end : command_monitor_thread

result_monitor result_monitor_h;
result_transaction result;

initial begin : result_monitor_thread
	result = new("result");
	forever begin
	
		read_serial_sout(result.C_data, result.alu_flags, result.rec_3b_CRC, result.err_flags, result.parity_bit);
		result_monitor_h.write_to_monitor(result);
	
	end
end : result_monitor_thread

endinterface