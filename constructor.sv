class rectangle;
  int length, width;

  // Constructor with default values
  function new(int x = 1, int y = 1);
    this.length = x;
    this.width = y;
  endfunction

  // Function to calculate area
  function int area();
    return length * width;
  endfunction

  // Function to calculate perimeter
  function int perimeter();
    return 2 * (length + width);
  endfunction
endclass

module test;
  rectangle r1, r2, r3;
  int a1, a3, p1;

  initial begin
    r1 = new(3, 5);
    r2 = new(4, 2); // Providing both length and width explicitly
    r3 = new(); // Uses default values (1,1)

    a1 = r1.area();   // Corrected function call with ()
    p1 = r2.perimeter(); // Corrected function call with ()
    a3 = r3.area();   // Corrected function call with ()

    // Display results
    $display("Area of r1: %0d", a1);
    $display("Perimeter of r2: %0d", p1);
    $display("Area of r3: %0d", a3);
  end
endmodule

/*expected output :
a1=15
p1=12
a3=1 */
