module RegisterFile(
	input clk,
	input reset
	input [4:0] adr1, 
	input [4:0] adr2, 
	input [4:0] writeadr, 
	input [31:0] WriteData,
	input RegWrite, 
	output reg [31:0] ReadData1, 
	output reg [31:0] ReadData2, 
);
    reg [31:0] registers[31:0];
	always @(posedge reset) begin
		// registers[0] <= 32'h00000000;
		// set default values
	end
	always @(adr1, adr2) begin
		ReadData1 <= registers[adr1];
  		ReadData2 <= registers[adr2];
	end
	always @(negedge clock) begin
  		if (RegWrite == 1)begin
			registers[writeadr] <= WriteData;
      	end
  	end
endmodule
