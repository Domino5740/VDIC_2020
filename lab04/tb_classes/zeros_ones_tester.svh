class zeros_ones_tester extends random_tester;
	`uvm_component_utils (zeros_ones_tester)
	
	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction : new
	
	function bit[31:0] get_data();
		
		bit zero_ones;
		
		zero_ones = $random;
		if(zero_ones == 1'b0)
			return 32'h00000000;
		else if(zero_ones == 1'b1)
			return 32'hFFFFFFFF;
	endfunction

endclass : zeros_ones_tester