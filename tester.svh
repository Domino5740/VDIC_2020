class tester;
	
	virtual alu_bfm bfm;
	
	function new(virtual alu_bfm b);
		bfm = b;
	endfunction : new

	protected function tester_op_t get_op();
		
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
	
	protected function bit[31:0] get_data();
		
		bit [1:0] zero_ones;
		
		zero_ones = $random;
		if(zero_ones == 2'b00)
			return 32'h00000000;
		else if(zero_ones == 2'b11)
			return 32'hFFFFFFFF;
		else
			return $random();
	endfunction

	task execute();
		
		bit [31:0] A_data, B_data;
		tester_op_t tester_op_set;
	
		bfm.reset_alu();
		
		repeat(1000) begin
			
			tester_op_set = get_op();
			A_data = get_data();
			B_data = get_data();
			
			bfm.test_op(A_data, B_data, tester_op_set);
			
			#1500;
		end
		
		$display("PASSED");
		$finish();
	endtask : execute

endclass : tester