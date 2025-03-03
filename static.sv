class Packet2;
    int a = 0;
endclass

class Packet;
    bit [15:0]  addr;
    bit [7:0]   data;
    int         ctr = 0;
    static int  static_ctr = 0;
    static Packet2 pkt = new();
    function new (bit [15:0] ad, bit [7:0] d);
        this.addr = ad;
        this.data = d;
        this.static_ctr++;
        this.ctr++;
        $display ("static_ctr=%0d ctr=%0d addr=0x%0h data=0x%0h pkt=%0h", static_ctr, ctr, addr, data, pkt);
    endfunction

    static function void print_no_objs();
        $display ("no of objects of class packet = %0d", static_ctr);
    endfunction
endclass

module tb;
	initial begin
		Packet 	p1, p2, p3;
		p1 = new (16'hdead, 8'h12);
		p2 = new (16'hface, 8'hab);
		p3 = new (16'hcafe, 8'hfc);

        p1.print_no_objs();
	end
endmodule


/* expected output 
static_ctr=1 ctr=1 addr=0xdead data=0x12 pkt=10002
static_ctr=2 ctr=1 addr=0xface data=0xab pkt=10002
static_ctr=3 ctr=1 addr=0xcafe data=0xfc pkt=10002
no of objects of class packet = 3 */
