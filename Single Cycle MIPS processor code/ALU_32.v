module ALU_32_bits(
	output reg [31:0]ALUResult,
	output reg Zero,
	input [31:0]SrcA,SrcB,
	input [2:0] ALUControl
);

	parameter AND = 3'b000,
			  OR = 3'b001,
			  ADD = 3'b010,
			  NOTUSED1 = 3'b011,
			  SUB = 3'b100,
			  MULT = 3'b101,
			  SLT = 3'b110,
			  NOTUSED2 = 3'b111;
	always @(*)begin
		case (ALUControl)
			AND : ALUResult = SrcA & SrcB ;
			OR  : ALUResult = SrcA | SrcB ;
			ADD : ALUResult = SrcA + SrcB ;
			SUB : ALUResult = SrcA - SrcB ;
			MULT : ALUResult = SrcA * SrcB ;
			SLT : if( SrcA < SrcB) ALUResult = 32'b1; else ALUResult = 32'b0;
		endcase
		if(ALUResult == 0) Zero = 1'b1; else Zero = 1'b0;
	
	end

endmodule