class minmax_sequence extends uvm_sequence #(sequence_item);
	`uvm_object_utils(minmax_sequence)

   	function new (string name = "");
    	super.new(name);
	endfunction : new

	sequence_item seq_item;
	
	task body();

		`uvm_create(seq_item)
		`uvm_info("MINMAX_SEQ", "START", UVM_MEDIUM)
		
		repeat(100000) begin : tester_loop
			
			`uvm_rand_send_with(seq_item, { A_data dist {'h00000000 := 1, ['h00000001 : 'hFFFFFFFE] :/ 1, 'hFFFFFFFF := 1};
                      	B_data dist {'h00000000 := 1, ['h00000001 : 'hFFFFFFFE] :/ 1, 'hFFFFFFFF := 1};})
			
		end : tester_loop
		
	endtask : body

endclass : minmax_sequence