class sequence_item extends uvm_sequence_item;
	
	rand bit signed [31:0] A_data;
	rand bit signed [31:0] B_data;
	rand tester_op_t tester_op;
	rand opcode_t opcode;
	bit [3:0]  sent_4b_CRC;
	bit data_error;
   
   constraint rand_op {tester_op dist {[no_op_test : bad_crc_op_test] :/ 1};}
   constraint rand_opcode {opcode dist {and_opcode := 1, add_opcode := 1, or_opcode := 1, sub_opcode := 1};}
   
   	function new (string name = "");
    	super.new(name);
	endfunction : new

`uvm_object_utils_begin(sequence_item)
	`uvm_field_int(A_data, UVM_ALL_ON)
	`uvm_field_int(B_data, UVM_ALL_ON)
	`uvm_field_enum(tester_op_t, tester_op, UVM_ALL_ON)
	`uvm_field_enum(opcode_t, opcode, UVM_ALL_ON)
	`uvm_field_int(sent_4b_CRC, UVM_ALL_ON)
	`uvm_field_int(data_error, UVM_ALL_ON)
`uvm_field_utils_end

endclass : sequence_item