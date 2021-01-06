class driver extends uvm_driver #(sequence_item);
	`uvm_component_utils(driver)
	
	virtual alu_bfm bfm;
	
	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction : new
	
	function void build_phase(uvm_phase phase);
		if(!uvm_config_db #(virtual alu_bfm)::get(null, "*", "bfm", bfm))
			`uvm_fatal("DRIVER", "Failed to get BFM");
	endfunction : build_phase
	
	task run_phase(uvm_phase phase);
		
		sequence_item seq_item;
		
		forever begin : seq_loop
			seq_item_port.get_next_item(seq_item);
			bfm.test_op(seq_item.A_data, seq_item.B_data, seq_item.tester_op, seq_item.opcode);
			seq_item_port.item_done();
		end : seq_loop
	endtask : run_phase
	
endclass : driver