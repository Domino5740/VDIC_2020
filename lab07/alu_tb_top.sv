/******************************************************************************
* DVT CODE TEMPLATE: testbench top module
* Created by dorlowski on Jan 26, 2021
* uvc_company = do, uvc_name = alu
*******************************************************************************/

module alu_tb_top;

	import uvm_pkg::*;
	import do_alu_pkg::*;
	

	// Clock and reset signals
	reg clock;
	reg reset;

	do_alu_if vif(clock, reset);

	mtm_Alu DUT (.clk(clock), .rst_n(vif.rst_n), .sin(vif.sin), .sout(vif.sout));

	initial begin
		// Propagate the interface to all the components that need it
		uvm_config_db#(virtual do_alu_if)::set(uvm_root::get(), "*", "m_do_alu_vif", vif);
		// Start the test
		run_test();
	end

	// Generate clock
	always
		#5 clock=~clock;

	// Generate reset
	initial begin
		reset <= 1'b1;
		clock <= 1'b1;
		#21 reset <= 1'b0;
		#51 reset <= 1'b1;
	end
endmodule
