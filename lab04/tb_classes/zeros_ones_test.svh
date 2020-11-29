class zeros_ones_test extends uvm_test;
	`uvm_component_utils(zeros_ones_test)
	
	env env_h;
	
	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction : new
	
	function void build_phase(uvm_phase phase);
		
		env_h = env::type_id::create("env_h", this);
		
		base_tester::type_id::set_type_override(zeros_ones_tester::get_type());
		
	endfunction : build_phase
	
	virtual function void start_of_simulation_phase(uvm_phase phase);
		
		super.start_of_simulation_phase(phase);
		uvm_top.print_topology();
		
	endfunction : start_of_simulation_phase
	
endclass : zeros_ones_test