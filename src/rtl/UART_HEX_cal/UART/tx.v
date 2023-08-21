module tx(
    input clk,
    input n_rst,
    input t_gen,
    input [7:0] u_out,
    input u_vaild,
    
    output reg txd
);

assign t_gen;
reg [1:0] c_state;
reg [1:0] n_state;

reg [3:0] cnt;
reg [3:0] cnt2; 

always @(posedge clk or negedge n_rst) begin
    if(!n_rst) begin
        c_state <= IDEL;
    end
    else begin
        c_state <= n_state;
    end

end 

endmodule 