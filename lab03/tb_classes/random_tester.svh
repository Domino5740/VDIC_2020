class random_tester extends base_tester;
	`uvm_component_utils (random_tester)
	
	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction : new
	
	virtual function tester_op_t get_op();
		
		bit[2:0] op_choice;
		
		op_choice = $random;
		case(op_choice)
			3'b000	:	return and_op_test;
			3'b001	:	return or_op_test;
			3'b010	:	return add_op_test;
			3'b011	:	return sub_op_test;
			3'b100  :	return no_op_test;
			3'b101  :	return rst_op_test;
			3'b110  :	return bad_data_op_test;
			3'b111  :	return bad_crc_op_test;
		endcase
	endfunction
	
	virtual function bit[31:0] get_data();
			return $random();
	endfunction

endclass : random_tester