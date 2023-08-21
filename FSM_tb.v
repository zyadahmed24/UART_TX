`timescale 1ns/1ps

module FSM_tb;

parameter period = 5;

reg        Data_Valid_tb;
reg        PAR_EN_tb;
reg        ser_done_tb;
reg        clk_tb;
reg        rst_tb;
wire       ser_en_tb;
wire [1:0] mux_sel_tb;
wire       busy_tb;

FSM DUT(Data_Valid_tb, PAR_EN_tb, ser_done_tb, clk_tb, rst_tb, ser_en_tb, mux_sel_tb, busy_tb);

always #(0.5*period) clk_tb = ~clk_tb;

initial begin

    clk_tb = 'b0;
    rst_tb = 'b1;
    ser_done_tb = 'b0;
    #(10*period);


    rst_tb = 'b0;
    #period;
    rst_tb = 'b1;
    #(5*period);

    PAR_EN_tb = 'b0;
    Data_Valid_tb = 'b1;
    #period;
    Data_Valid_tb = 'b0;    
    #(8.5*period);
    ser_done_tb = 'b1;
    #(20*period);

    ser_done_tb = 'b0;
    PAR_EN_tb = 'b0;
    Data_Valid_tb = 'b1;
    #period;
    Data_Valid_tb = 'b0;    
    #(8.5*period);
    ser_done_tb = 'b1;
    #(20*period);


    $stop;
end

endmodule