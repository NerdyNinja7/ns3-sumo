//we are creating an object of Usb2Packet and assigning the parent class handle to point to the object of Usb2Packet.class UsbBasePacket;
    bit [31:0] data;
    bit [9:0] addr;
    int usb_version;

    function new();
       usb_version = 1;
    endfunction //new()

    function void printf();
        $display("Base version packet");
        $display("usb_version: %0d", usb_version);
        $display("addr: 0x%0h", addr);
        $display("data: %0d", data);
    endfunction

    virtual function int send(int data);
        this.data = data;
        $display("Sending usb base packet");
        return data;
    endfunction
endclass: UsbBasePacket

class Usb2Packet extends UsbBasePacket;
    function new();
        data = 0;
        usb_version = 2;
    endfunction //new()

    function void printf();
        $display("USB version 2 packet");
        $display("addr: 0x%0h", addr);
        $display("data: %0d", data);
    endfunction

    function int send(int data);
        this.data = data;
        $display("Sending usb2 packet");
        return this.data;
    endfunction
endclass: Usb2Packet

module test;
    UsbBasePacket packet;
    Usb2Packet usb2_pkt;

    initial begin
        usb2_pkt = new();

        packet = usb2_pkt;

        packet.printf();
        packet.send(45);
    end
endmodule
