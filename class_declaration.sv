class Car; 
// Properties string brand; 
int speed; 
// Method to display car details function void display();
 $display("Brand: %s, Speed: %0d", brand, speed); 
endfunction 
endclass 

module testbench;
 initial begin 
// Create an object of the Car class 
Car myCar = new(); 
// Assign values to properties 
myCar.brand = "Tesla"; 
myCar.speed = 120; 
// Call the method to display details 
myCar.display();
 end 
endmodule

//Expected Output:

//Brand: Tesla, Speed: 120
