//  demo interface with 2 inputs and 1 output.
interface demo_intf;
    logic in1;
    logic in2;
    logic out1;

endinterface //demo_intf

//  example rtl which outputs xor of 2 inputs
module ex_dut(demo_intf intf);
    assign intf.out1 = intf.in1 ^ intf.in2;
endmodule

//  testbench where interface and dut is instantiated and connected.
//  As tb is small and only one heirarchy is present thus both way of
//  declaring interface as discussed is okay to use.
module tb_top();
    demo_intf intf();
    ex_dut dut(intf);

    initial begin
        $monitor("in1 = %b, in2 = %b, out1 = %b",intf.in1, intf.in2, intf.out1);

        intf.in1 <= 1'b1;
        intf.in2 <= 1'b0;

        #20;
        intf.in1 <= 1'b1;
        intf.in2 <= 1'b1;

        #20;
        intf.in1 <= 1'b0;
        intf.in2 <= 1'b1;
    end
endmodule

/* expected outcome 
# in1 = 1, in2 = 0, out1 = 1
# in1 = 1, in2 = 1, out1 = 0
# in1 = 0, in2 = 1, out1 = 1
