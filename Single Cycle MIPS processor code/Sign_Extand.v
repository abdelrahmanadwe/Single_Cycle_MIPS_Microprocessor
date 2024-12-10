module Sign_Extand(
	output reg [31:0]out,
	input  [15:0]in
);
	always @(*)begin
		if(in[15] == 1'b1)begin
			out [31:16] = 16'b1111_1111_1111_1111;
			out [15:0] = in;
		end
		else begin
			out [31:16] = 16'b0;
			out [15:0] = in;
		end
	end
	

endmodule