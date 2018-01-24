

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

endmodule // ripple_carry_adder_subtractor

module full_adder(S, Cout, A, B, Cin);
   output S;
   output Cout;
   input  A;
   input  B;
   input  Cin;

   assign S=A^B^Cin;
   assign Cout= (A & B) | ((A | B) & Cin);

endmodule