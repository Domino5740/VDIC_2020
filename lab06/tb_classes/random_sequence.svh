class random_sequence extends uvm_sequence #(sequence_item);
	`uvm_object_utils(random_sequence)
		
	function new(string name = "");
		super.new(name);
	endfunction : new
	
	sequence_item seq_item;
	
	task body();

		`uvm_create(seq_item)
		`uvm_info("RANDOM_SEQ", "START", UVM_MEDIUM)
		
		repeat(10000) begin : tester_loop
			
			`uvm_rand_send(seq_item);
			
		end : tester_loop
		
	endtask : body
	
endclass : random_sequence
