`timescale 1ns/1ps

module serializer_tb;

parameter period = 5;

reg [7:0] p_data_tb;
reg       clk_tb;
reg       rst_tb;
reg       ser_en_tb;
wire      ser_data_tb;
wire      ser_done_tb;

serializer DUT(p_data_tb, clk_tb, rst_tb, ser_en_tb, ser_data_tb, ser_done_tb);

always #(0.5*period) clk_tb = ~clk_tb;

initial begin
    clk_tb = 'b0;
    rst_tb = 'b1;
    #(10*period);


    rst_tb = 'b0;
    #period;
    rst_tb = 'b1;
    #period;

    p_data_tb = 'b10111001;
    #(period);

    ser_en_tb = 'b1;
    #(3*period);
    p_data_tb = 'b10110101;
    #(7*period);
    ser_en_tb = 'b0;
    #period;

    p_data_tb = 'b10001001;
    #(period);

    ser_en_tb = 'b1;
    #(3*period);
    p_data_tb = 'b1000101;
    #(7*period);
    ser_en_tb = 'b0;
    #period;


    $stop;
end

endmodule