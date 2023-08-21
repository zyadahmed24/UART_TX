module serializer (
    input  wire [7:0] P_DATA,
    input  wire       clk, rst,
    input  wire       ser_en,
    output reg        ser_data,
    output reg        ser_done
);

reg [3:0] counter;
//reg [7:0] P_DATA_reg;
reg [7:0] Received_Data;
reg       count_done;

// always @(*) begin
//     if(count_done == 'b1)
//     begin
//         P_DATA_reg = 'b0;
//     end
//     else
//     begin
//         P_DATA_reg = P_DATA;
//     end
// end

always @(posedge clk or negedge rst) begin
    if(!rst)
    begin
        Received_Data <= 'b0;
    end
    else if(!ser_en)
    begin
        Received_Data <= P_DATA;
    end
end

always @(posedge clk or negedge rst) begin
    if(!rst)
    begin
        counter <= 'b0;
    end
    else if(count_done == 0 && ser_en == 'b1)
    begin
        counter <= counter + 'b1;
    end
    else if(ser_en == 'b0)
    begin
        counter <= 'b0;
    end
end

always @(*) begin
    if(counter == 'd8)
    begin
        count_done = 'b1;
    end
    else if(ser_en == 'b0)
    begin
        count_done = 'b0;
    end
    else
    begin
        count_done = 'b0;
    end
end

always @(*) begin
    if(count_done == 'b1)
    begin
        ser_done = 'b1;
    end
    else
    begin
        ser_done = 'b0;
    end
end

always @(posedge clk or negedge rst) begin
    if(!rst)
    begin
        ser_data <= 'b0;
    end
    else if(ser_en=='b1)
    begin
        if(! count_done)
        begin
            {ser_data, Received_Data[7:1]} <= Received_Data;
        end
    end
end

endmodule