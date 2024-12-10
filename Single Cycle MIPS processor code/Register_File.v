module RegisterFile(
	output [31:0] ReadData1,    // Data from first read register
    output [31:0] ReadData2,    // Data from second read register
    input Clock,reset,          // Clock and reset signals
    input RegWrite,             // Register write enable
    input [4:0] Address1Read,   // First register to read
    input [4:0] Address2Read,   // Second register to read
    input [4:0] Address3Write,  // Register to write
    input [31:0] WriteData      // Data to write

);

    // Register file with 32 32-bit registers
    reg [31:0] registers [0:31];
	
    // Read data
    assign ReadData1 = registers[Address1Read];
    assign ReadData2 = registers[Address2Read];

    // Write data
    always @(posedge Clock or negedge reset) begin
		if (!reset) begin : resetvalues
			integer i;
			for (i = 0; i < 32; i = i + 1) begin
				registers[i] <= 32'b0;
			end
		end
		else begin
			if (RegWrite) begin
				registers[Address3Write] <= WriteData;
			end
		end
    end

endmodule
