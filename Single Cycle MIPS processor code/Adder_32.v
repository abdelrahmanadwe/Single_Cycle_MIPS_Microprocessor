module Adder_32_bits(
	output[31:0]out,
	input [31:0]in1,in2
);

	assign out = in1 + in2;

endmodule