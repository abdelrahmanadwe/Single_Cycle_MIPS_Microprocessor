module ControlUnit(
    output RegDst,       // Register destination
    output ALUSrc,       // ALU source
    output MemToReg,     // Memory to register
    output RegWrite,     // Register write enable
    output MemWrite,     // Memory write enable
    output Branch,       // Branch signal
    output Jump,         // Jump signal
    output [2:0] ALUControl, // ALU control signal
	input [5:0] opcode,      // Opcode field from the instruction
    input [5:0] funct        // Function field from the instruction (for R-type)
);

    wire [1:0] ALUOp;  // ALU operation
    // Instantiate Main Decoder
    MainDecoder maindecoder(
		.ALUOp(ALUOp),  
		.MemToReg(MemToReg),    
		.MemWrite(MemWrite),    
		.Branch(Branch),      
		.ALUSrc(ALUSrc),      
		.RegDst(RegDst),      
		.RegWrite(RegWrite),    
		.Jump(Jump),        
		.opcode(opcode)       
	);

    // Instantiate ALU Decoder
    ALUDecoder aluDecoder (
        .ALUOp(ALUOp),
        .Funct(funct),
        .ALUControl(ALUControl)
    );

endmodule
