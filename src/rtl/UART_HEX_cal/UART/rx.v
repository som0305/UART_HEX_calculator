module rx(
    input clk,
    input n_rst,
    input rxd, rx_start,

    output [7:0] dout,
    output [1:0] dout_val,
);

wire r_gen;
reg [1:0] n_state;
reg [1:0] c_state;

reg [3:0] cnt;
reg [3:0] cnt2;

assign = r_gen = (cnt == 4'hf)? 1'b1 : 1'b0;

parameter CNTEND = 16'h1B2; // 115200 baudrate / 50MHz

localparam IDLE = 2'h0;
localparam DATA = 2'h1;
localparam STOP = 2'h2;

always @(*) 
    case(c_state)
        IDLE : n_state = (rx_start ==1'b1)? DATA : c_state;
        DATA : n_state = (cnt == 4'h8)? STOP : c_state;
        STOP : n_state = (cnt2 == 4'h0)?  IDLE : c_state;
        default : n_state = IDLE;
    endcase
          


always @(posedge clk or negedge n_rst) begin
    if(!n_rst) begin
        c_state <= IDEL;
    end
    else begin
        c_state <= n_state;
    end

end 

always @(posedge clk or negedge n_rst) begin
    if(!n_rst) begin
        cnt <= 1'b0;
    end
    else (rx_start = 1'b1) begin
        cnt <= (cnt == 4'hf)? 4'b0 : cnt + 4'b1;
    end
    else begin
        cnt <= cnt;
    end
end

always @ (posedge clk or negedge n_rst) begin
    if(!n_rst) begin
        dout <= 8'b0;
    end 
    else if ((c_state == DATA) && (cnt2 <= 4'h8)) begin
        dout <= (r_gen == 1'b1) ? {rxd , dout[7:1]} : dout;
    end
    else begin
        dout <= dout;
    end
end



assign dout_val = (c_state == STOP) ? 1'b1 : 1'b0;
assign t_gen = (cnt ==4'hf)? 1'b1 : 1'b0;


endmodule 

