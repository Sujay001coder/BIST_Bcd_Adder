module top_module ();
	reg clk;
    reg rst;
    reg [15:0] a;
    reg [15:0] b;
    reg tm;
    wire [31:0] tp;
    wire [16:0] ao;
    wire [16:0] oro;
    bist bi1(clk,rst,a,b,tm,tp,ao,oro);
    initial begin
        clk=0;
        rst=0;
        tm=1;
        a=16'h1111;
        b=16'h2222;
        if (~tm)
        begin
            $monitor("a=%h,b=%h,ao=%h",a[15:0],b[15:0],ao[16:0]);
            #1 $finish;
        end
        #2 
        rst=1;
        #4
        rst=0;
      //  $monitor("x=%h,y=%h,ao=%h,sig=%h",tp[15:0],tp[31:16],ao,oro);
        #10224
       // $display("x=%h,y=%h,ao=%h,sig=%h,xor=%h",tp[15:0],tp[31:16],ao,oro,(oro==17'h17431));
        if (tm & ~(oro==17'h17431))
            $display("MACHINE IN TEST MODE \nOUTPUT RESPONSE %h !=17431 \nMACHINE IS FAULTY ",oro);
      else if (tm & (oro==17'h17431))//17'h17431 is the good signature
           $display("MACHINE IN TEST MODE \n SIGNATUER %h =17431 \nMACHINE IS NOT FAULTY ",oro);
       // $display("TEST MODE \n ",tp[15:0],tp[31:16],ao,oro,~(oro==17'h17431));
        #10250 $finish;
    end
    always begin
       #5 clk=~clk;
    end
endmodule
