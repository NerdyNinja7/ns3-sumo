//  Example interface having modport to define different
//  direction for the same signals. Also note we are passing
//  clk as an argument.
interface intf( input logic clk);
    // Declare the signals inside the interface
    logic [7:0] data_in;
    logic [7:0] data_out;
    logic [3:0] addr;
    logic rw;

    // Define the modports
    modport dut (input clk, input addr, rw, data_in, output data_out);
    modport tb(input clk, data_out, output addr, rw, data_in);
endinterface

//  Sample dut using interface defined above
module sample_dut(intf.dut vif);
    reg [7:0] mem [0:15];
    always_ff @(posedge vif.clk) begin
        if(vif.rw) begin
            mem[vif.addr] <= vif.data_in;
        end
        else begin
            vif.data_out <= mem[vif.addr];
        end
    end
endmodule

//  Test bench top where we are instantiating interface and
//  connecting dut to the test bench. Inside drv block the inputs
//  to DUT are driven and inside monitor block the signals are
//  sampled and monitored.
module tb_top;
    bit clk;
    intf vif(clk);

    sample_dut dut(vif);

    always #10 clk = ~clk;

    initial begin: drive
        @(negedge clk);
        vif.rw = 1'b1;
        vif.addr = 4'ha;
        vif.data_in = 8'h2f;

        #20;
        @(negedge clk);
        vif.rw = 1'b1;
        vif.addr = 4'h3;
        vif.data_in = 8'h11;

        #20;
        @(negedge clk);
        vif.rw = 1'b0;
        vif.addr = 4'h3;
    end

    always@(posedge clk) begin: monitor
        $display("Sampled signals at t = %0t", $time);
        $strobe("rw = %b, addr = %0h, data_in= %0h, data_out = %0h",
                 vif.rw, vif.addr, vif.data_in, vif.data_out);
    end
endmodule


/* expected outcome 
Sampled signals at t = 10
# rw = x, addr = x, data_in= x, data_out = x
# Sampled signals at t = 30
# rw = 1, addr = a, data_in= 2f, data_out = x
# Sampled signals at t = 50
# rw = 1, addr = 3, data_in= 11, data_out = x
# Sampled signals at t = 70
# rw = 0, addr = 3, data_in= 11, data_out = 11
# Sampled signals at t = 90
# rw = 0, addr = 3, data_in= 11, data_out = 11
