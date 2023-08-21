module mux(
    input wire [1:0] mux_sel,
    input wire       start_bit,
    input wire       stop_bit,
    input wire       ser_data,
    input wire       par_bit,
    output reg       TX_out
);

always @(*) begin
    case(mux_sel)
        'b00 : TX_out = start_bit;
        'b01 : TX_out = stop_bit;
        'b10 : TX_out = ser_data;
        'b11 : TX_out = par_bit;
    endcase
end
    
endmodule