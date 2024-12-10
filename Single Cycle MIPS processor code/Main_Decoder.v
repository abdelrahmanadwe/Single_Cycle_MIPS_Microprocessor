module MainDecoder(
    output reg [1:0] ALUOp,  // Control signal for the ALU operation
    output reg MemToReg,     // Control signal to select memory to register
    output reg MemWrite,     // Control signal to enable memory write
    output reg Branch,       // Control signal to indicate a branch
    output reg ALUSrc,       // Control signal to select ALU source
    output reg RegDst,       // Control signal to select destination register
    output reg RegWrite,     // Control signal to enable register write
    output reg Jump,         // Control signal to indicate a jump
	input [5:0] opcode       // Opcode field from the instruction
);

    always @(*) begin
        case(opcode)
            6'b000000: begin // R-type instructions
				Jump     = 1'b0;
				ALUOp    = 2'b10;
				MemWrite = 1'b0;
                RegWrite = 1'b1;
                RegDst   = 1'b1;
				ALUSrc   = 1'b0;
				MemToReg = 1'b0;
				Branch   = 1'b0;  
            end
            6'b100011: begin // lw
				Jump     = 1'b0;
				ALUOp    = 2'b00;
				MemWrite = 1'b0;
                RegWrite = 1'b1;
                RegDst   = 1'b0;
				ALUSrc   = 1'b1;
				MemToReg = 1'b1;
				Branch   = 1'b0;
            end
            6'b101011: begin // sw
				Jump     = 1'b0;
				ALUOp    = 2'b00;
				MemWrite = 1'b1;
                RegWrite = 1'b0;
                RegDst   = 1'b0;
				ALUSrc   = 1'b1;
				MemToReg = 1'b1;
				Branch   = 1'b0;
            end
            6'b000100: begin // beq
				Jump     = 1'b0;
				ALUOp    = 2'b01;
				MemWrite = 1'b0;
                RegWrite = 1'b0;
                RegDst   = 1'b0;
				ALUSrc   = 1'b0;
				MemToReg = 1'b0;
				Branch   = 1'b1;
            end
            6'b001000: begin // addi
				Jump     = 1'b0;
				ALUOp    = 2'b00;
				MemWrite = 1'b0;
                RegWrite = 1'b1;
                RegDst   = 1'b0;
				ALUSrc   = 1'b1;
				MemToReg = 1'b0;
				Branch   = 1'b0;
            end
            6'b000010: begin // j
               	Jump     = 1'b1;
				ALUOp    = 2'b00;
				MemWrite = 1'b0;
                RegWrite = 1'b0;
                RegDst   = 1'b0;
				ALUSrc   = 1'b0;
				MemToReg = 1'b0;
				Branch   = 1'b0;
            end
            // Add more instructions as needed
            default: begin
                // Default control signal values
                RegWrite = 1'b0;
                MemToReg = 1'b0;
                MemWrite = 1'b0;
                Branch   = 1'b0;
                ALUSrc   = 1'b0;
                RegDst   = 1'b0;
                ALUOp    = 2'b00;
                Jump     = 1'b0;
            end
        endcase
    end
	
endmodule
