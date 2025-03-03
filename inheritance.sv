class parent;
    int x =5;
    function new();
       $display("inside new of parent class");
    endfunction //new()
    task printf();
        $display("This is parent class");
    endtask
endclass //parent


class subclass extends parent;
    function new();
        $display("inside new of child class");
    endfunction //new()

    task printf();
        $display("This is subclass");
        $display("calling parent's printf method from subclass");
        super.printf();
    endtask
endclass //subclass extends parent

module inheritence;
    initial
    begin
        parent p;
        subclass s;

        p=new();
        s=new();

        s.x = 10;

        $display("Value of x using p: %d", p.x);
        $display("Value of x using s: %d", s.x);

        p.printf();
        s.printf();
    end
endmodule


/* expected oucome 
inside new of parent class
inside new of parent class
inside new of child class
Value of x using p: 5
Value of x using s: 10
This is parent class
This is subclass
calling parent's printf method from subclass
This is parent class
