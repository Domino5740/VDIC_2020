`timescale 1ns/1ps
module tester(alu_bfm bfm);

import alu_pkg::*;

initial begin : tester
	
	bit [31:0] A_data, B_data;
	tester_op_t tester_op_set;

	bfm.reset_alu();
	
	repeat(1000) begin
		
		tester_op_set = bfm.get_op();
		A_data = bfm.get_data();
		B_data = bfm.get_data();
		
		bfm.test_op(A_data, B_data, tester_op_set);
		
		#1500;
	end
	
	$display("PASSED");
	$finish();
end : tester

endmodule