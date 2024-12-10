module ALUDecoder(
    output reg [2:0] ALUControl, // ALU control signal
    input [1:0] ALUOp,           // ALU operation control from main decoder
    input [5:0] Funct            // Function field from the instruction

);

	parameter AND      = 3'b000,
			  OR       = 3'b001,
			  ADD      = 3'b010,
			  NOTUSED1 = 3'b011,
			  SUB      = 3'b100,
			  MUL      = 3'b101,
			  SLT      = 3'b110,
			  NOTUSED2 = 3'b111;
    always @(*) begin
        case(ALUOp)
            2'b00: ALUControl = ADD; // Load/Store operations use ADD
            2'b01: ALUControl = SUB; // Branch operations use SUB
            2'b10: begin
                case(Funct)
                    6'b100000: ALUControl = ADD; // ADD
                    6'b100010: ALUControl = SUB; // SUB
                    6'b100100: ALUControl = AND; // AND
                    6'b100101: ALUControl = OR; // OR
                    6'b101010: ALUControl = SLT; // SLT
                    6'b011100: ALUControl = MUL; // MUL
                    default:   ALUControl = 3'bxxx; // Undefined function
                endcase
            end
            default: ALUControl = ADD; // default add
        endcase
    end

endmodule
