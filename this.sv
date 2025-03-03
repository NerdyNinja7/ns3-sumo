class packet;
    bit [4:0] length;
    bit [15:0] addr;
    function new(bit [15:0] addr, bit [4:0] l=1);
        this.length = l;
        this.addr = addr;
    endfunction: new
    function void print_packet();
        $display("addr = 0x%0h", addr);
        $display("lenght = %0d", length);
    endfunction: print_packet
endclass: packet
module class_ex_1;
    initial begin
        packet pkt1, pkt2;
        pkt1 = new('ha4a4,10);
        pkt1.print_packet();
        pkt2 = new('hb623);
        pkt2.length = 22;
        pkt2.print_packet();
    end
endmodule


/* expected output
addr = 0xa4a4
lenght = 10
 addr = 0xb623
lenght = 22  */
