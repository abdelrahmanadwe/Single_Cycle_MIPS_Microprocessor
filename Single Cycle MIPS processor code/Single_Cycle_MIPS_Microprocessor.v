module Single_Cycle_MIPS_Microprocessor(
	output [15:0] TestValue,
	input reset,
	input clock
);
	wire [31:0] PCCurrentInstruction,PCPlus4, PCNextInstruction, PCBranch, PCBranchOrNot, PCJump ;
	wire [31:0] instruction;
	wire [31:0] readData1Reg, readData2Reg, writeDataReg, readDataRam, WriteDataRam, ALUResult, SignImm, SrcA, SrcB;
	wire [31:0] beqshiftout;
	wire MemToReg, MemWrite, Branch, ALUSrc, RegDst, RegWrite, Jump, MemRead;
	wire [4:0] Address1ReadReg, Address2ReadReg, Address3WriteReg;

    wire [5:0] opcode;
    wire [5:0] funct;
    wire [2:0] ALUControl;
    wire [1:0] ALUOp;
	wire zero;
	
	ProgramCounter pc(
		.ProgramCounterOut(PCCurrentInstruction),
		.ProgramCounterIn(PCNextInstruction),
		.clock(clock),
		.reset(reset)
	);
	
	Adder_32_bits add4(
		.out(PCPlus4),
		.in1(PCCurrentInstruction),
		.in2(32'b100)
	);
	
	InstructionMemory ROM(
		.instruction(instruction), 
		.Address(PCCurrentInstruction)       
	);
	
	assign Address1ReadReg = instruction[25:21];
	assign Address2ReadReg = instruction[20:16];
	
	mux_2x1 #(.N(32)) address3writeregistermux(
		.MuxOut(Address3WriteReg),
		.MuxIn1(instruction[20:16]),
		.MuxIn2(instruction[15:11]),
		.sel(RegDst)
	);

	RegisterFile registers(
		.ReadData1(readData1Reg),
		.ReadData2(readData2Reg),  
		.Clock(clock),
		.reset(reset),
		.RegWrite(RegWrite),          
		.Address1Read(Address1ReadReg), 
		.Address2Read(Address2ReadReg), 
		.Address3Write(Address3WriteReg),
		.WriteData(writeDataReg)  
	);
	Sign_Extand sign(
		.out(SignImm),
		.in(instruction[15:0])
	);
	
	Shift_Left_Twice #(.in_width(32),.out_width(32)) beqshift(
		.out(beqshiftout),
		.in(SignImm)
	);
	
	Adder_32_bits addbranch(
		.out(PCBranch),
		.in1(beqshiftout),
		.in2(PCPlus4)
	);
	mux_2x1 #(.N(32)) branchornotmux(
		.MuxOut(PCBranchOrNot),
		.MuxIn1(PCPlus4),
		.MuxIn2(PCBranch),
		.sel(Branch&zero)
	);
	
	Shift_Left_Twice #(.in_width(26),.out_width(32)) jumpshift(
		.out(PCJump),
		.in(instruction[25:0])
	);
	
	mux_2x1 #(.N(32)) jumpornotmux(
		.MuxOut(PCNextInstruction),
		.MuxIn1(PCBranchOrNot),
		.MuxIn2({PCPlus4[31:28],PCJump[27:0]}),
		.sel(Jump)
	);
	
	mux_2x1 #(.N(32)) SrcBmux(
		.MuxOut(SrcB),
		.MuxIn1(readData2Reg),
		.MuxIn2(SignImm),
		.sel(ALUSrc)
	);
	
	assign SrcA = readData1Reg;
	ALU_32_bits ALU(
		.ALUResult(ALUResult),
		.Zero(zero),
		.SrcA(SrcA),
		.SrcB(SrcB),
		.ALUControl(ALUControl)
	);
	
	// Extract opcode and funct fields from instruction
    assign opcode = instruction[31:26];
    assign funct  = instruction[5:0];
	ControlUnit controlunit(
		.RegDst(RegDst),       
		.ALUSrc(ALUSrc),       
		.MemToReg(MemToReg),   
		.RegWrite(RegWrite),        
		.MemWrite(MemWrite),   
		.Branch(Branch),        
		.Jump(Jump),         
		.ALUControl(ALUControl),
		.opcode(opcode),      
		.funct(funct)    
	);
	
	assign WriteDataRam = readData2Reg;
	Data_Memory RAM(
		.ReadData(readDataRam),     
		.TestValue(TestValue),    
		.Clock(clock),
		.Reset(reset),
		.Address(ALUResult),      
		.WriteData(WriteDataRam),    
		.WriteEnable(MemWrite)   
	);
	
	mux_2x1 #(.N(32)) loademux(
		.MuxOut(writeDataReg),
		.MuxIn1(ALUResult),
		.MuxIn2(readDataRam),
		.sel(MemToReg)
	);

endmodule

`timescale 1ns/1ps
module Single_Cycle_MIPS_Microprocessor_tb();

	reg clock ,reset;
	wire [15:0] TestValue;
	
	Single_Cycle_MIPS_Microprocessor MIPS(
		.TestValue(TestValue),
		.reset(reset),
		.clock(clock)
	);
	
	initial begin
		clock = 0;
		forever #10 clock = ~clock;
	end
	initial begin
		reset = 0;
		# 20 reset = 1;
	end
endmodule