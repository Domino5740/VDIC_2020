`timescale 1ns/1ps
module top;
	
	import uvm_pkg::*;
	`include "uvm_macros.svh"
	import alu_pkg::*;

	mtm_Alu DUT (.clk(bfm.clk), .rst_n(bfm.rst_n), .sin(bfm.sin), .sout(bfm.sout));

	alu_bfm bfm();
	
	
	initial begin
		uvm_config_db #(virtual alu_bfm)::set(null, "*", "bfm", bfm);
		run_test();
	end

endmodule