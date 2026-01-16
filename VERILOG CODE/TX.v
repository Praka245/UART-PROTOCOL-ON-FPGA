`timescale 1ns / 1ns


module transmitter(
	input wire [7:0] data_in,
	input wire En_btn,
	input wire clk_100m,
	input wire clken,
	output reg tx,
	output wire tx_busy
);


reg [7:0] data = 8'h00;
reg [2:0] bitpos = 3'h0;
reg [1:0] state = STATE_IDLE;

initial begin
	 tx = 1'b1;
end

parameter STATE_IDLE	= 2'b00;
parameter STATE_START	= 2'b01;
parameter STATE_DATA	= 2'b10;
parameter STATE_STOP	= 2'b11;


always @(posedge clk_100m) begin
	case (state)
	STATE_IDLE: begin
		if (En_btn) begin
			state <= STATE_START;
			data <= data_in;
			bitpos <= 3'h0;
		end
	end
	STATE_START: begin
		if (clken) begin
			tx <= 1'b0;
			state <= STATE_DATA;
		end
	end
	STATE_DATA: begin
		if (clken) begin
			if (bitpos == 3'h7)
				state <= STATE_STOP;
			else
				bitpos <= bitpos + 3'h1;
			tx <= data[bitpos];
		end
	end
	STATE_STOP: begin
		if (clken) begin
			tx <= 1'b1;
			state <= STATE_IDLE;
		end
	end
	default: begin
		tx <= 1'b1;
		state <= STATE_IDLE;
	end
	endcase
end

assign tx_busy = (state != STATE_IDLE);

endmodule