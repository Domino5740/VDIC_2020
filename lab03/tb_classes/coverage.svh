class coverage extends uvm_component;
	
	`uvm_component_utils(coverage)
	
	virtual alu_bfm bfm;
	bit [31:0] A_data, B_data;
	tester_op_t tester_op_set;
	
	covergroup op_cov;
		option.name = "op_cov";
		coverpoint tester_op_set {
			bins A1_all_op[] = {[no_op_test:sub_op_test], bad_data_op_test, bad_crc_op_test};
			bins A2_rst_to_op[] = (rst_op_test => [no_op_test : sub_op_test], bad_data_op_test, bad_crc_op_test);
			bins A3_op_to_rst[] = ([no_op_test:sub_op_test], bad_data_op_test, bad_crc_op_test => rst_op_test);
			bins A4_twoops[] = ([no_op_test:sub_op_test], bad_data_op_test, bad_crc_op_test [* 2]);
			bins A5_bad_data = bad_data_op_test;
			bins A6_bad_crc = bad_crc_op_test;
			bins A7_no_op = no_op_test;
		}
	endgroup
	
	covergroup zeros_or_ones_on_ops;
		option.name = "cg_zeros_or_ones_on_ops";
		
		all_ops : coverpoint tester_op_set {
			ignore_bins null_ops = {rst_op_test};
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
			bins B1_add_00 = binsof (all_ops) intersect {add_op_test} &&
							(binsof (a_leg.zeros) || binsof (b_leg.zeros));
			bins B1_and_00 = binsof (all_ops) intersect {and_op_test} &&
							(binsof (a_leg.zeros) || binsof (b_leg.zeros));
			bins B1_or_00 = binsof (all_ops) intersect {or_op_test} &&
							(binsof (a_leg.zeros) || binsof (b_leg.zeros));
			bins B1_sub_00 = binsof (all_ops) intersect {sub_op_test} &&
							(binsof (a_leg.zeros) || binsof (b_leg.zeros));
		// #B2 simulate all ones input for all the operations
			bins B2_add_ff = binsof (all_ops) intersect {add_op_test} &&
							(binsof (a_leg.ones) || binsof (b_leg.ones));
			bins B2_and_ff = binsof (all_ops) intersect {and_op_test} &&
							(binsof (a_leg.ones) || binsof (b_leg.ones));
			bins B2_or_ff = binsof (all_ops) intersect {or_op_test} &&
							(binsof (a_leg.ones) || binsof (b_leg.ones));
			bins B2_sub_ff = binsof (all_ops) intersect {sub_op_test} &&
							(binsof (a_leg.ones) || binsof (b_leg.ones));
		ignore_bins others_only = binsof(a_leg.others) && binsof(b_leg.others);
		}
	endgroup
	
	function new(string name, uvm_component parent);
		super.new(name, parent);
		op_cov = new();
		zeros_or_ones_on_ops = new();
	endfunction : new
	
	function void build_phase(uvm_phase phase);
		if(!uvm_config_db #(virtual alu_bfm)::get(null, "*", "bfm", bfm))
			$fatal(1, "Failed to get BFM");
	endfunction : build_phase
	
	task run_phase(uvm_phase phase);
		forever begin : sampling_block 
			@(negedge bfm.clk);
			A_data = bfm.A_data;
			B_data = bfm.B_data;
			tester_op_set = bfm.tester_op_set;
			op_cov.sample();
			zeros_or_ones_on_ops.sample();
		end : sampling_block
	endtask : run_phase

endclass : coverage