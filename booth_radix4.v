

module booth_radix4 (a,b,clk,reset,out,flag);
parameter N=16;
input [N-1:0] a;
input [N-1:0] b;
output [2*N-1:0] out;
output reg flag=0;; 
input clk,reset;
wire [N:0] abar;
wire [2*N-1:0] bbar;
wire [2*N-1:0] mux_out1;
wire [2*N-1:0] mux_out2;
wire [2*N-1:0] extend;
wire sel1,sel2,op;
wire carry,overflow;
reg [2*N-1:0] temp=1'd0;
reg temp1=1;

signextension signextend(b,extend);
shifter boothshifter(a,extend,clk,reset,abar,bbar);
multiplexer mux1(bbar,(bbar<<1),mux_out1,sel1);
multiplexer mux2(32'b0,mux_out1,mux_out2,sel2);
boothrecording boothrecord(abar[2:0],sel1,sel2,op);
ripple_carry_adder_subtractor rcas(out,carry,overflow,temp,mux_out2,op);

always @(posedge clk)
begin
	if (reset==0)
	begin
		temp=1'd0;
		flag<=0;
	end
	else if (temp1==1)
	begin
		temp=1'd0;
		flag<=0;
		temp1=0;
	end
	else
	begin
		temp=out;
		if ((abar==17'b00000000000000000)||(abar==17'b11111111111111111))
			flag <=1;
	end 
end


endmodule




module ripple_carry_adder_subtractor(S, C, V, A, B, Op);
   parameter N=16;
   output [(2*N-1):0] S;
   output 	C;
   output 	V;
   input [(2*N-1):0] A;
   input [(2*N-1):0] B;
   input 	Op;  // The operation: 0 => Add, 1=>Subtract.
   genvar i;

   wire [(2*N):0] temp_c;
   wire [(2*N-1):0] temp_xor;
   wire [(2*N-1):0] temp_op;

   assign temp_c[0]=Op;
   assign temp_op={{(2*N-1){Op}},Op};
   assign temp_xor=B^temp_op;
   assign C=temp_c[(2*N)]^Op;
   assign V=temp_c[(2*N)]^temp_c[(2*N-1)];
 
   generate
		for(i = 0; i <= (2*N-1); i = i + 1)
		begin
			full_adder u_full_adder_inst (S[i], temp_c[i+1], A[i], temp_xor[i], temp_c[i]);
		end
   endgenerate

endmodule


module full_adder(S, Cout, A, B, Cin);
   output S;
   output Cout;
   input  A;
   input  B;
   input  Cin;

   assign S=A^B^Cin;
   assign Cout= (A & B) | ((A | B) & Cin);

endmodule

module multiplexer (In1,In2,Out,Sel);
	parameter N=16;
	input [2*N-1:0] In1;
	input [2*N-1:0] In2;
	input Sel;
	output [2*N-1:0] Out;
	assign Out=Sel?In2:In1;
endmodule

module boothrecording(x,sel1,sel2,op);
input [2:0] x;
output reg sel1,sel2,op;

always@(x) begin
	if ((x==3'b001) || (x==3'b010)) begin
		sel1<=1'b0;
		sel2<=1'b1;
		op<=1'b0;
	end
	else if (x==3'b011) begin
		sel1<=1'b1;
		sel2<=1'b1;
		op<=1'b0;
	end
	else if (x==3'b100) begin
		sel1<=1'b1;
		sel2<=1'b1;
		op<=1'b1;
	end
	else if ((x==3'b101) || (x==3'b110)) begin
		sel1<=1'b0;
		sel2<=1'b1;
		op<=1'b1;
	end
	else begin
		sel1<=1'b0;
		sel2<=1'b0;
		op<=1'b0;
	end
end
endmodule

module shifter (a,b,clk,reset,abar,bbar);
parameter N=16;
input [N-1:0] a;
input [2*N-1:0] b;
input clk,reset;
output reg signed [N:0] abar;
output reg signed [2*N-1:0] bbar;
reg temp1=1;

always@(posedge clk)
begin
	if (reset==0)
	begin
		abar=a<<1'd1;
		bbar=b;
	end	
	else if (temp1==1)
	begin 
		abar=a<<1'd1;
		bbar=b;
		temp1=0;
	end
	else
	begin
		abar=abar>>>2;
		bbar=bbar<<2;
	end
end

endmodule

module signextension (in,out);
parameter N=16;
input [N-1:0] in;
output [2*N-1:0] out;
assign out = {{(N){in[N-1]}},in};
endmodule
 