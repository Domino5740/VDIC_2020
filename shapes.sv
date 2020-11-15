virtual class shape;
	protected real width;
	protected real height;
	
	function new(real w, real h);
		width = w;
		height = h;
	endfunction : new
	
	pure virtual function real get_area();
	pure virtual function void print();
endclass: shape

class rectangle extends shape;
	
	function new(real w, real h);
		super.new(w, h);
	endfunction : new
	
	function real get_area();
		return width * height;
	endfunction : get_area
	
	function void print();
		$display("Rectangle w=%g h=%g area=%g", width, height, get_area());
	endfunction : print
	
endclass: rectangle

class square extends shape;
	
	function new(real w);
		super.new(w, w);
	endfunction : new
	
	function real get_area();
		return width * width;
	endfunction : get_area
	
	function void print();
		$display("Square w=%g area=%g", width, get_area());
	endfunction : print
	
endclass : square

class triangle extends shape;
	
	function new(real w, real h);
		super.new(w, h);
	endfunction : new
	
	function real get_area();
		return (width * height) / 2;
	endfunction : get_area
	
	function void print();
		$display("Triangle w=%g h=%g area=%g", width, height, get_area());
	endfunction : print
	
endclass: triangle

class shape_factory;
	
	static function shape make_shape(string shape_type, real w, real h);
		
		rectangle rectangle_h;
		square square_h;
		triangle triangle_h;
		
		case(shape_type)
			"rectangle" : begin
				rectangle_h = new(w, h);
				return rectangle_h;
			end
			"square" : begin
				square_h = new(w);
				return square_h;
			end
			"triangle" : begin
				triangle_h = new(w, h);
				return triangle_h;
			end
			default : $fatal(1, "No such shape: ", shape_type);
		endcase
		
	endfunction : make_shape
	
endclass : shape_factory

class shape_reporter #(type T = shape);
	
	protected static T shape_storage [$];
	protected static real total_area;
	
	static function void store_shape(T shape);
		shape_storage.push_back(shape);
	endfunction : store_shape
	
	static function void report_shapes();
		foreach(shape_storage[i]) begin
			total_area += shape_storage[i].get_area();
			shape_storage[i].print();
		end
		$display("Total area: %g", total_area);
	endfunction : report_shapes
	
endclass : shape_reporter

module top;
	initial begin
		
		shape shape_h;
		rectangle rectangle_h;
		square square_h;
		triangle triangle_h;
		string shape;
		real width, height;
		int shapes_list;
		
		shapes_list = $fopen("./shapes.txt", "r");
		if (shapes_list) begin
		end
		else $fatal(1, "File was NOT opened succesfully: ", shapes_list);
		
		while($fscanf(shapes_list, "%s %g %g", shape, width, height) == 3) begin
			shape_h = shape_factory::make_shape(shape, width, height);
			if($cast(rectangle_h, shape_h))
				shape_reporter#(rectangle)::store_shape(rectangle_h);
			else if($cast(square_h, shape_h))
				shape_reporter#(square)::store_shape(square_h);
			else if($cast(triangle_h, shape_h))
				shape_reporter#(triangle)::store_shape(triangle_h);
			else $fatal(1, "Wrong shape in file: ", shape);
		end
		shape_reporter#(rectangle)::report_shapes();
		shape_reporter#(square)::report_shapes();
		shape_reporter#(triangle)::report_shapes();
		$finish("Simulation comppleted succesfully");
	end
endmodule : top