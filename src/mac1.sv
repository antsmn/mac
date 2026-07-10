module mac
  import pg_pkg::*;
(
    input  logic           clk,
    input  logic           rstn,
    input  logic           v_i,
    input  logic           a_signed_i,
    input  logic           b_signed_i,
    input  logic           c_signed_i,
    input  logic [  W-1:0] a_i,
    input  logic [  W-1:0] b_i,
    input  logic [  W-1:0] c_i,
    output logic           v_o,
    output logic [2*W-1:0] p_o
);

  logic [  K-1:0][2*W-1:0] p_1;
  logic [    1:0][2*W-1:0] p_2;
  logic [    1:0][2*W-1:0] p_3;
  logic [2*W-1:0]          p_4;

  pg i_pg (.*, .p_o(p_1));

  csa #(.K(K), .W(2 * W)) i_csa (.p_i(p_1), .p_o(p_2));

  assign p_3[0] = p_2[0];
  assign p_3[1] = p_2[1] << 1;

  cpa #(.W(2 * W)) i_cpa (.a_i(p_3[0]), .b_i(p_3[1]), .s_o(p_4));

  always_ff @(posedge clk, negedge rstn) begin
    if (!rstn) v_o <= '0;
    else v_o       <= v_i;
  end
  always_ff @(posedge clk, negedge rstn) begin
    if (!rstn) p_o    <= '0;
    else if (v_i) p_o <= p_4;
  end

endmodule
