/******************************************************************************
* DVT CODE TEMPLATE: package
* Created by dorlowski on Jan 26, 2021
* uvc_company = do, uvc_name = alu
*******************************************************************************/

package do_alu_pkg;

	
//FIXME ALWAYS CHECK THIS WHEN ADDING NEW FILES
	// UVM macros
	`include "uvm_macros.svh"
	// UVM class library compiled in a package
	import uvm_pkg::*;

	// Configuration object
	`include "do_alu_config_obj.svh"
	// Sequence item
	`include "do_alu_item.svh"
	// Monitor
	`include "do_alu_monitor.svh"
	// Coverage Collector
	`include "do_alu_coverage_collector.svh"
	// Driver
	`include "do_alu_driver.svh"
	// Sequencer
	`include "do_alu_sequencer.svh"
	// Agent
	`include "do_alu_agent.svh"
	// Environment
	`include "do_alu_env.svh"
	// Sequence library
	`include "do_alu_seq_lib.svh"
	// Base test
	`include "do_alu_base_test.svh"
	// Example test
	`include "do_alu_example_test.svh"

endpackage : do_alu_pkg
