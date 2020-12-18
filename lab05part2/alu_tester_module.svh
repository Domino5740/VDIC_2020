`timescale 1ns/1ps
module alu_tester_module(alu_bfm bfm);

	import alu_pkg::*;

	function tester_op_t get_op();
		
		bit[2:0] op_choice;
		
		op_choice = $random;
		case(op_choice)
			3'b000	:	return and_op_test;
			3'b001	:	return or_op_test;
			3'b010	:	return add_op_test;
			3'b011	:	return sub_op_test;
			3'b100  :	return no_op_test;
			3'b101  :	return rst_op_test;
			3'b110  :	return bad_data_op_test;
			3'b111  :	return bad_crc_op_test;
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

	function bit[31:0] get_data();
		
	bit [1:0] zero_ones;
		
	zero_ones = $random;
	if(zero_ones == 2'b00)
		return 32'h00000000;
	else if(zero_ones == 2'b11)
		return 32'hFFFFFFFF;
	else
		return $random();
	endfunction

	initial begin : tester
	
		bit [31:0] A_data, B_data;
		tester_op_t tester_op_set;
		opcode_t rand_opcode;

		bfm.reset_alu();

		repeat(10000) begin

			tester_op_set = get_op();
			rand_opcode = get_opcode(); 
			A_data = get_data();
			B_data = get_data();

			bfm.test_op(A_data, B_data, tester_op_set, rand_opcode);

			#1500;
		end

		$display("PASSED");
		$finish();
	end : tester

endmodule : alu_tester_module
