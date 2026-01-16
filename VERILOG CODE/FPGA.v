module uart_fpga(
    input  wire clk_100m,      // ZedBoard clock
    input  wire [7:0] sw,     // 8 switches
    input  wire btn,          // button to trigger TX
    output wire tx,           // UART TX (to JA1)
    input  wire rx,           // UART RX (from JA2)
    output wire [7:0] led     // LEDs to show received data
);

wire tx_busy;
wire rdy;
reg  rdy_clr = 0;
wire [7:0] rxdata;

// Instantiate your UART
uart my_uart(
    .data_in(sw),         // switches as input data
    .En_btn(btn),      // send on button press
    .clk_100m(clk_100m),
    .tx(tx),
    .tx_busy(tx_busy),
    .rx(rx),
    .ready(ready),
    .ready_clr(ready_clr),
    .data_out(rxdata)
);

// Show received data on LEDs
assign led = rxdata;

// Clear rdy after one cycle (optional)
always @(posedge clk_100m) begin
    if (rdy) 
        rdy_clr <= 1;
    else
        rdy_clr <= 0;
end

endmodule
