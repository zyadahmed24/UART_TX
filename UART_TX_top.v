module uart_tx (
    input  wire       PAR_EN,
    input  wire [7:0] P_DATA,
    input  wire       Data_Valid,
    input  wire       PAR_TYP,
    input  wire       clk, rst,
    output wire       TX_out,
    output wire       busy
);

///////////// Declarations /////////////
wire       start_bit = 'b0;
wire       stop_bit  = 'b1;
wire       par_bit;
wire [1:0] mux_sel;
wire       ser_en;
wire       ser_data;
wire       ser_done;

///////////// Instantiation /////////////
serializer serunit(P_DATA, clk, rst, ser_en, ser_data, ser_done);
FSM        fsmunit(Data_Valid, PAR_EN, ser_done, clk, rst, ser_en, mux_sel, busy);
parityCalc parunit(P_DATA, Data_Valid, PAR_TYP, clk, rst, par_bit);
mux        muxunit(mux_sel, start_bit, stop_bit, ser_data, par_bit, TX_out);


    
endmodule