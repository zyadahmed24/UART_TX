`timescale 1ns/1ps

module parityCalc_tb;

parameter period = 5;

reg [7:0] P_DATA_tb;
reg       Data_Valid_tb;
reg       PAR_TYP_tb;
reg       clk_tb;
reg       rst_tb;
wire      par_bit_tb;

parityCalc DUT(P_DATA_tb, Data_Valid_tb, PAR_TYP_tb, clk_tb, rst_tb, par_bit_tb);

always #(0.5*period) clk_tb = ~clk_tb;

initial begin
    clk_tb = 'b0;
    rst_tb = 'b1;
    #(10*period);

    rst_tb = 'b0;
    #period;
    rst_tb = 'b1;
    #period;

    P_DATA_tb  = 'b10111001;
    PAR_TYP_tb = 'b0;
    #(period);

    Data_Valid_tb = 'b1;
    #(10*period);
    Data_Valid_tb = 'b0;
    #period;    

    P_DATA_tb  = 'b10111001;
    PAR_TYP_tb = 'b1;
    #(period);

    Data_Valid_tb = 'b1;
    #(10*period);
    Data_Valid_tb = 'b0;
    #period;        

    $stop;
end

endmodule