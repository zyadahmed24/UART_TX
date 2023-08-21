module FSM (
    input wire       Data_Valid,
    input wire       PAR_EN,
    input wire       ser_done,
    input wire       clk, rst,
    output reg       ser_en,
    output reg [1:0] mux_sel,
    output reg       busy
);

reg IDLE = 'b0;
reg OPRT = 'b1;

reg current;
reg next;

reg         proc_flag;
reg [3:0]   counter;
reg [1:0]   mux_sel_reg;

always @(posedge clk or negedge rst) begin
    if(!rst)
    begin
        current <= IDLE;
    end
    else
    begin
        current <= next;
    end
end


always @(*) begin
    case(current)
        IDLE : begin
            if(Data_Valid)
            begin
                next = OPRT;
            end
            else
            begin
                next = IDLE;
            end
        end
        OPRT : begin
            if(proc_flag)
            begin
                next = OPRT;
            end
            else
            begin
                next = IDLE;
            end
        end
    endcase
end

always @(*) begin
    case(current)
        IDLE : begin
            mux_sel_reg = 'b01;
            if(counter == 'd10 || counter == 'd11)
            begin
                busy = 'b1;
            end
            else
            begin
                busy = 'b0;
            end
            ser_en = 'b0;
        end
        OPRT : begin
            proc_flag   = 'b1;
            if(mux_sel != 'b1)
            begin
                busy  = 'b1;
            end
            else
            begin
                busy = 'b0;
            end
            if(counter == 'b0)
            begin
                mux_sel_reg = 'b00;
            end
            else if(!ser_done && counter!='b0)
            begin
                ser_en      = 'b1;
                mux_sel_reg = 'b10;
            end
            else if(PAR_EN && counter=='d9)
            begin
                mux_sel_reg = 'b11;
            end
            else
            begin
                mux_sel_reg = 'b01;
                proc_flag = 'b0;
            end
        end
        default : begin
            proc_flag = 'b0;
            mux_sel_reg = 'b01;
            ser_en = 'b0;
            busy = 'b0;
        end
    endcase
end
    

always @(posedge clk or negedge rst) begin
   if(!rst) 
   begin
    mux_sel <= 'b01;
   end
   else
   begin
    mux_sel <= mux_sel_reg;
   end
end

always @(posedge clk or negedge rst) begin
   if(!rst) 
   begin
    counter <= 'b0;
   end
   else if(current == OPRT)
   begin
    counter <= counter + 'b1;
   end
   else
   begin
    counter <= 'b0;
   end
end
    
    
endmodule