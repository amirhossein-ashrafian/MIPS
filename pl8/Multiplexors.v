module MUX_MR_EX_rs(
    input forward,
    input [4:0] ReadData, DecodeData,
    output reg [4:0] EX_rs
);

    always @(*) begin
        if(forward) EX_rs = ReadData;
        else EX_rs = DecodeData;
    end

endmodule

module MUX_MR_EX_rt(
    input forward,
    input [4:0] ReadData, DecodeData,
    output reg [4:0] EX_rt
);

    always @(*) begin
        if(forward) EX_rt = ReadData;
        else EX_rt = DecodeData;
    end

endmodule

module MUX_MR_ID_rs(
    input forward,
    input [4:0] ReadData, DecodeData,
    output reg [4:0] ID_rs
);

    always @(*) begin
        if(forward) ID_rs = ReadData;
        else ID_rs = DecodeData;
    end

endmodule

module MUX_MR_ID_rt(
    input forward,
    input [4:0] ReadData, DecodeData,
    output reg [4:0] ID_rt
);

    always @(*) begin
        if(forward) ID_rt = ReadData;
        else ID_rt = DecodeData;
    end

endmodule