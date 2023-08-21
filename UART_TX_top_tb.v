`timescale  1ns/1ps

module uart_tx_tb;

/////////////////////////////////////////////////////////
///////////////////// Parameters ////////////////////////
/////////////////////////////////////////////////////////

parameter period = 5;
parameter DWIDTH = 8;
parameter DDEPTH = 10;

/////////////////////////////////////////////////////////
///////////////////// Declaratios ///////////////////////
/////////////////////////////////////////////////////////

reg        par_en_tb;
reg  [7:0] p_data_tb;
reg        data_valid_tb;
reg        par_typ_tb;
reg        clk_tb;
reg        rst_tb;
wire       tx_out_tb;
wire       busy_tb;

/////////////////////////////////////////////////////////
///////////////////// Instantiation /////////////////////
/////////////////////////////////////////////////////////

uart_tx DUT(par_en_tb, p_data_tb, data_valid_tb, par_typ_tb, clk_tb, rst_tb, tx_out_tb, busy_tb);

/////////////////////////////////////////////////////////
///////////////////// Clock generation //////////////////
/////////////////////////////////////////////////////////

always #(0.5*period) clk_tb = ~clk_tb;


/////////////////////////////////////////////////////////
///////////////////// Initial Block /////////////////////
/////////////////////////////////////////////////////////

initial begin
    //System functions.
    $dumpfile("UART_TX_TOP.vcd") ;       
    $dumpvars; 

    //initialization.
    init;

    //reset.
    reset;


    //TEST_1 tests when no parity.
    send_data_parity_conf('b10100011,0,0);
    check_serial('b01010001110,1);

    //TEST_2 tests when odd parity.
    send_data_parity_conf('b10101011,1,1);
    check_serial('b01010101101,2);

    //TEST_3 tests when even parity.
    send_data_parity_conf('b01100001,1,0);
    check_serial('b00110000111,3);

    //TEST_4 testing accepting new data while transmetting.
    send_data_parity_conf('b00011010,1,0);
    check_serial_acc_test('b00001101011,4,'b01110011);

    $stop;
end


/////////////////////////////////////////////////////////
///////////////////// Tasks /////////////////////////////
/////////////////////////////////////////////////////////

/////////////// Signals Initialization //////////////////
task init;
begin
    clk_tb = 'b0;
    rst_tb = 'b1;
    data_valid_tb = 'b0;
    par_en_tb = 'b0;
    par_typ_tb = 'b0;
    p_data_tb  = 'b0;
end
endtask

//////////////////////// Reset /////////////////////////
task reset;
begin
    rst_tb = 'b0;
    #period;
    rst_tb = 'b1;
end
endtask

////////////////// Send data with parity configrations ////////////////////
task send_data_parity_conf;
input reg [7:0] byte;
input reg en,typ;
begin
    par_en_tb  = en;
    par_typ_tb = typ;    
    p_data_tb = byte;
    //#period;
    data_valid_tb = 'b1;
    #period;
    data_valid_tb = 'b0;
end
endtask

////////////// Task for TEST_4 //////////////
task send_data_parity_conf_acc_test;
input reg [7:0] byte;
input reg en,typ;
begin
    p_data_tb = byte;
    par_en_tb  = en;
    par_typ_tb = typ;    
end
endtask

////////////////// Check Out Response  //////////////////
task check_serial;
input reg [11:0] acc;
input integer   index;
integer i;
reg [11:0] get_out;
begin
    @(posedge busy_tb);
    if(par_en_tb)
    begin
        for(i=11;i>=0;i=i-1)
        begin
            get_out[i] = tx_out_tb;
            #period;
        end
    end
    else
    begin
        for(i=11;i>=0;i=i-1)
        begin
            get_out[i] = tx_out_tb;
            #period;
        end
        get_out[0] = 'b0;
        #period;
    end
    if(get_out == acc)
    begin
        $display("TEST number %0d is PASSED",index);
    end
    else
    begin
        $display("TEST number %0d is FAILED",index);
    end
end
endtask

////////////////// Task for TEST_4 //////////////////
task check_serial_acc_test;
input reg [11:0] acc;
input integer   index;
input reg [7:0] new_data;
integer i;
reg [11:0] get_out;
begin
    @(posedge busy_tb);
    if(par_en_tb)
    begin
        for(i=11;i>=0;i=i-1)
        begin
            get_out[i] = tx_out_tb;
            #period;
            data_valid_tb = 'b0;
            if(i==3)
            begin
                data_valid_tb = 'b1;
                send_data_parity_conf_acc_test(new_data,1,0);
            end
        end
    end
    else
    begin
        for(i=11;i>=0;i=i-1)
        begin
            get_out[i] = tx_out_tb;
            #period;
            data_valid_tb = 'b0;
            if(i==3)
            begin
                data_valid_tb = 'b1;
                send_data_parity_conf_acc_test(new_data,1,0);
            end
        end
        get_out[0] = 'b0;
        #period;
    end
    if(get_out == acc)
    begin
        $display("TEST number %0d is PASSED",index);
    end
    else
    begin
        $display("TEST number %0d is FAILED",index);
    end
end
endtask
endmodule 