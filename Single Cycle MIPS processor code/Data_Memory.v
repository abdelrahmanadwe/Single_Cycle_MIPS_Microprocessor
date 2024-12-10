module Data_Memory(
	output [31:0] ReadData,      // Data output
	output [15:0] TestValue,     // test value
    input Clock,Reset,           // Clock and reset signals
    input [31:0] Address,        // Address input
    input [31:0] WriteData,      // Data to be written
    input WriteEnable            // Memory write enable
);
	wire [31:0] WordAddress;
    // 1KB- RAM 
    reg [7:0] memory [0:1023];
    
    // reset values of data memory with zeros
    always @(negedge Reset) begin : resetvalues
        integer i;
        for (i = 0; i < 1024; i = i + 1) begin
            memory[i] = 8'b0;
        end
    end
	
	assign WordAddress = {Address[31:2],2'b00}; 
    // Read data
    assign ReadData = {memory[WordAddress[9:0]+3],memory[WordAddress[9:0]+2],memory[WordAddress[9:0]+1],memory[WordAddress[9:0]]};
	assign TestValue = {memory[1],memory[0]};
    // Write data
    always @(posedge Clock) begin
        if (WriteEnable) begin
            {memory[WordAddress[9:0]+3],memory[WordAddress[9:0]+2],memory[WordAddress[9:0]+1],memory[WordAddress[9:0]]} <= WriteData;
        end
    end

endmodule
