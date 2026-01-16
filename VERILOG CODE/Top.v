`timescale 1ns / 1ns

module Top(
		input wire [7:0] data_in,
	    input wire En_btn,
	    input wire clk_100m,
	    output wire tx,
	    output wire tx_busy,
	    input wire rx,
	    output wire ready,
	    input wire ready_clr,
	    output wire [7:0] data_out
);

wire rxclk_en, txclk_en;

baud_rate_gen uart_baud(.clk_100m(clk_100m), .rxclk_en(rxclk_en), .txclk_en(txclk_en));


transmitter uart_tx(.data_in(data_in), .En_btn(En_btn), .clk_100m(clk_100m), .clken(txclk_en), .tx(tx), .tx_busy(tx_busy));

receiver uart_rx(.rx(rx), .ready(ready), .ready_clr(ready_clr), .clk_100m(clk_100m), .clken(rxclk_en), .data(data_out));


endmodule
