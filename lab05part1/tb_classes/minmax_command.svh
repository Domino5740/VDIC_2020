class minmax_command extends random_command;
	`uvm_object_utils(minmax_command)

   	constraint data { A_data dist {'h00000000:=1, ['h00000001 : 'hFFFFFFFE]:=1, 'hFFFFFFFF:=1};
                      B_data dist {'h00000000:=1, ['h00000001 : 'hFFFFFFFE]:=1, 'hFFFFFFFF:=1};};
   
   	function new (string name = "");
    	super.new(name);
	endfunction : new

endclass : minmax_command