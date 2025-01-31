module PC (
  input clk , 
  input reset ,
  input stall
  input wire [31:0] PC_IN ,
  output reg [31:0] PC_OUT ,
);
always@(posedge reset) begin
  PC_OUT <= 32'h0000;
end
always @(posedge clk)begin
  //to support stalls from hazard detection unit
	if (stall ==0) begin
    PC_OUT <= PC_IN;
	end
end
endmodule
