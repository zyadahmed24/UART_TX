module parityCalc (
    input  wire [7:0] P_DATA,
    input  wire       Data_Valid,
    input  wire       PAR_TYP,
    input  wire       clk,rst,
    output reg        par_bit
);

reg par_bit_reg;

always @(*) begin
    if(Data_Valid)
    begin
        if(!PAR_TYP)
        begin
            par_bit_reg = ^(P_DATA);
        end
        else
        begin
            par_bit_reg = ~(^(P_DATA));
        end
    end
    else
    begin
        par_bit_reg = par_bit;
    end
end

always @(posedge clk or negedge rst) begin
    if(!rst)
    begin
        par_bit <= 0;
    end
    else
    begin
        par_bit <= par_bit_reg;
    end
end


endmodule