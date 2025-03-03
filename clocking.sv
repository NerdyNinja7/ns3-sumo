module dut(input clk, a, b, output reg c);
    always @(posedge clk)
        c <= a + b;
endmodule

module tb;
    bit clk;
    reg a, b;
    wire c;

    always #10 clk = ~clk;

    dut d1(.clk(clk), .a(a), .b(b), .c(c));

    clocking drv_cb @(posedge clk);
        default input #1 output #1;
        output a, b;
    endclocking

    clocking mon_cb_1 @(posedge clk);
        default input #1step;
        input a, b ,c;
    endclocking

    clocking mon_cb_2 @(posedge clk);
        default input #1;
        input a, b;
        input #0 c;
    endclocking

    initial begin
        drv_cb.a <= 1;
        drv_cb.b <= 0;
        #35;
        drv_cb.a <= 0;
        drv_cb.b <= 1;
    end

    always @(mon_cb_1) begin
        $display("[%0t] sampled from mon cb_1: a = %0b, b = %0b, c = %0b",$time, mon_cb_1.a, mon_cb_1.b, mon_cb_1.c);
        $display("[%0t] sampled from mon cb_2: a = %0b, b = %0b, c = %0b",$time, mon_cb_2.a, mon_cb_2.b, mon_cb_2.c);
    end
endmodule

/* expecetd outcome 
[10] sampled from mon cb_1: a = x, b = x, c = x
[10] sampled from mon cb_2: a = x, b = x, c = x
[30] sampled from mon cb_1: a = 1, b = 0, c = x
[30] sampled from mon cb_2: a = 1, b = 0, c = 1
[50] sampled from mon cb_1: a = 1, b = 0, c = 1
[50] sampled from mon cb_2: a = 1, b = 0, c = 1
[70] sampled from mon cb_1: a = 0, b = 1, c = 1
[70] sampled from mon cb_2: a = 0, b = 1, c = 1
[90] sampled from mon cb_1: a = 0, b = 1, c = 1
[90] sampled from mon cb_2: a = 0, b = 1, c = 1
