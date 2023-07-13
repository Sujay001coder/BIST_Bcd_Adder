module bist(input clk,
            input rst,
            input [15:0] a,
            input [15:0] b,
            input tm,
            output [31:0] tp,
            output [16:0] ao,
            output [16:0] oro);
    wire [15:0] c,d;
    wire p;
    assign {d[15:0],c[15:0]}=tm?tp:{b[15:0],a[15:0]};
    ca c1(clk,rst,tp);
    bcd_add b1(c,d,0,ao);
    ora o1(clk,rst,ao,oro);
endmodule
//CUT
module bcd_add ( 
    input [15:0] a, b,
    input cin,
    output [16:0] sum );
    wire carry[3:0];
    genvar i;
    bcd q1(a[3:0],b[3:0],cin,carry[0],sum[3:0]);
    generate for (i=2;i<=4;i=i+1)
        begin:bcd_add
            bcd p1(a[4*i-1:4*(i-1)],b[4*i-1:4*(i-1)],carry[i-2],carry[i-1],sum[4*i-1:4*(i-1)]);
        end
            endgenerate
    assign sum[16]=carry[3];
endmodule
module bcd(input [3:0]a,b,
           input cin,
           output carry,
           output  [3:0]sum);
  wire [3:0] sum1;
    
    wire carry1,carry2;
    assign {carry1,sum1}=a+b+cin;
  
    assign {carry2,sum}=(carry1)|(sum1[3]&sum1[2] | sum1[3]&sum1[1])? (sum1+4'b0110):sum1;
    assign carry =carry1|carry2|1'b0;
  //  assign {carry,sum}=(carry1)|(sum>9)? (sum1+4'b0110):sum1;
    
endmodule

//TPG

module dff(input clk,
           input rst,
           input in,
           output reg r);
    always @(posedge clk) begin
        if(rst) begin
            r<=1;
        end
        else begin
            r<=in;
        end
    end
endmodule
module ca(input clk,input rst,output reg [31:0] q);
    dff a (clk,rst,(q[1]^q[0]),q[0]);
    genvar i;
    generate for (i=1;i<16;i=i+1)
        begin:d_ff
            dff b(clk,rst,(q[2*i-2]^q[2*i]),q[2*i-1]);
            dff E(clk,rst,(q[2*i-1]^q[2*i]^q[2*i+1]),q[2*i]);
        end
    endgenerate
  
    dff c(clk,rst,(q[30]),q[31]);
endmodule

//ORA

module ora(input clk,input rst,input [16:0] o,output [16:0] q);
  genvar i;
  generate
    
      for(i=16;i>=0;i=i-1) 
      begin:gen_loop
          if(i==16||i==0) begin
          dff a(clk,rst,(o[i]^q[0]),q[i]);
        end
        else begin
          dff a(clk,rst,(o[i]^q[0]^q[i-1]),q[i]);
        end
      end
  endgenerate
endmodule
