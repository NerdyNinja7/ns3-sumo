module cdc_dut(input clk1, clk2, rst, a, b, req, output reg c, busy);
    reg temp_sum;

    always @(negedge rst) begin
        if(~rst) begin
            temp_sum <= 0;
            busy <= 0;
        end
    end
    always @(posedge clk1) begin
        if(~busy && req) begin
            temp_sum <= a + b;
            busy <= 1;
        end
    end

    always @(posedge clk2) begin
        c = temp_sum;
        busy <= 0;
    end
endmodule

module tb;
    bit clk1, clk2;
    reg a, b, rst, req;
    wire c, busy;
    always #10 clk1 = ~clk1;
    always #25 clk2 = ~clk2;

    cdc_dut dut(clk1, clk2, rst, a, b, req, c, busy);

    clocking drv_cb @(posedge clk1);
        default input #1step output #1;
        output a, b, req;
        input busy;
    endclocking

    clocking mon_cb_1 @(posedge clk1);
        input #1 a, b, req, busy;
    endclocking

    clocking mon_cb_2 @(posedge clk2);
        input #0 c, busy;
    endclocking

    // Driver
    initial begin
        //reset packet
        rst <= 0;
        drv_cb.req <= 0;
        drv_cb.a <= 0;
        drv_cb.b <= 0;
        @(drv_cb);
        wait(~mon_cb_2.busy);
        #10;
        rst <= 1;
        // 1st valid ip
        drv_cb.req <= 1;
        drv_cb.a <= 0;
        drv_cb.b <= 1;
        @(drv_cb);
        wait(~mon_cb_2.busy);
        @(drv_cb);
        drv_cb.req <= 0;
        @(drv_cb);
        #40;
        //2nd valid ip
        drv_cb.req <= 1;
        drv_cb.a <= 1;
        drv_cb.b <= 1;
        @(drv_cb);
        wait(~mon_cb_2.busy);
        @(drv_cb);
        drv_cb.req <= 0;
        @(drv_cb);
        #40;
        //3rd valid ip
        drv_cb.req <= 1;
        drv_cb.a <= 1;
        drv_cb.b <= 0;
        @(drv_cb);
        wait(~mon_cb_2.busy);
        @(drv_cb);
        drv_cb.req <= 0;
    end

    // Monitor (checker)
    always @(posedge mon_cb_1.req) begin
        forever begin
            @(mon_cb_2);
            if(~mon_cb_2.busy) break;
        end
        if(~mon_cb_2.busy) begin
            if(mon_cb_1.a + mon_cb_1.b == mon_cb_2.c )
                $display("[%0t] Output is expected. a = %0b, b = %0b, c = %0b", $time, mon_cb_1.a, mon_cb_1.b, mon_cb_2.c);
            else
                $display("[%0t] Output is not expected. a = %0b, b = %0b, c = %0b", $time, mon_cb_1.a, mon_cb_1.b, mon_cb_2.c);
        end
    end
endmodule

/* expected output 
[75] Output is expected. a = 0, b = 1, c = 1
[175] Output is expected. a = 1, b = 1, c = 0
[275] Output is expected. a = 1, b = 0, c = 1
