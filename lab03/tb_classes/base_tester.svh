virtual class base_tester extends uvm_component;
	`uvm_component_utils(base_tester)
	
	virtual alu_bfm bfm;
	
	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction : new
	
	function void build_phase(uvm_phase phase);
		if(!uvm_config_db #(virtual alu_bfm)::get(null, "*", "bfm", bfm))
			$fatal(1, "Failed to get BFM");
	endfunction : build_phase
	
	pure virtual function tester_op_t get_op();
	pure virtual function bit [31:0] get_data();
	
	task run_phase(uvm_phase phase);
		
		bit [31:0] A_data, B_data;
		tester_op_t tester_op_set;
		
		phase.raise_objection(this);
	
		bfm.reset_alu();
		
		repeat(1000) begin : tester_loop
			
			tester_op_set = get_op();
			A_data = get_data();
			B_data = get_data();
			
			bfm.test_op(A_data, B_data, tester_op_set);
			
			#1500;
			
		end : tester_loop
		
		phase.drop_objection(this);
		
	endtask : run_phase
	
endclass : base_tester