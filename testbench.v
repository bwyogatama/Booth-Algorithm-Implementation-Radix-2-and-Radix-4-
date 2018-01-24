
module testbench();

parameter N=16;

reg signed [N-1:0] a,b;
wire signed [2*N-1:0] c;
reg clk;
reg reset;
wire signed [2*N-1:0] out;
wire flag;
integer i;
integer count_clock_max=-1;

booth_radix4 dut(.a(a),.b(b),.clk(clk),.reset(reset),.out(out),.flag(flag));
assign c=a*b;

initial
begin
	clk=0;
	reset=1;
	for (i=1;i<=64;i=i+1)
	begin
	a=$random;b=$random; #200;
	if (out==(c))
	begin
		$display("Random Number ke-%d",i);
		$display("Hasil Simulasi: %d",out);
		$display("Hasil Perhitungan: %d",c);
		$display("Jumlah clock cycle yang dibutuhkan: %d",count_clock_max-1);
		$display("Hasil Simulasi Benar!!!");
		$display("===============================================================");
		
	end
	else
	begin
		$display("Random Number ke-%d",i);
		$display("Hasil Simulasi: %d",out);
		$display("Hasil Perhitungan: %d",c);
		$display("Jumlah clock cycle yang dibutuhkan: %d",count_clock_max-1);
		$display("Hasil Simulasi Salah!!!");
		$display("===============================================================");
	end
	count_clock_max=0;
	end
	$finish;
end

always
begin
	clk = ~clk; #5;
end

always @(posedge clk)
begin
	if (flag==0)
	begin
		count_clock_max=count_clock_max+1;
	end
end

endmodule
