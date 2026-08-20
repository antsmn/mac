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
  logic [K-1:0][2*W-1:0] p_0;

  pg i_pg (.*, .p_o(p_0));

  // FIXME assert size X / Y and csa K

  localparam X = K / 2;
  localparam Y = K - X;

  logic [X-1:0][2*W-1:0] p_1;
  logic [Y-1:0][2*W-1:0] p_2;
  logic [  1:0][2*W-1:0] p_3;
  logic [  1:0][2*W-1:0] p_4;

  assign p_1 = p_0[X-1:0];
  assign p_2 = p_0[K-1:X];

  csa #(X, 2 * W) i_csa_e0_1 (.p_i(p_1), .p_o(p_3));
  csa #(Y, 2 * W) i_csa_e0_2 (.p_i(p_2), .p_o(p_4));

  logic [3:0][2*W-1:0] p_5;
  logic [3:0][2*W-1:0] p_6;

  assign p_5[2] = p_3[0];
  assign p_5[3] = p_4[0];
  assign p_5[0] = p_3[1] << 1;
  assign p_5[1] = p_4[1] << 1;

  always_ff @(posedge clk, negedge rstn) begin
    if (!rstn) p_6 <= '0;
    else if (v_i) p_6 <= p_5;
  end

  logic [1:0][2*W-1:0] p_7;

  csa #(4, 2 * W) i_csa_e1_1 (.p_i(p_6), .p_o(p_7));

  logic [2*W-1:0] p_8;
  logic [2*W-1:0] p_9;
  logic [2*W-1:0] p_10;

  assign p_8 = p_7[0];
  assign p_9 = p_7[1] << 1;

  cpa #(2 * W) i_cpa_e1_1 (.a_i(p_8), .b_i(p_9), .s_o(p_10));

  logic v_q;

  always_ff @(posedge clk, negedge rstn) begin
    if (!rstn) v_q <= '0;
    else v_q       <= v_i;
  end
  always_ff @(posedge clk, negedge rstn) begin
    if (!rstn) v_o <= '0;
    else v_o       <= v_q;
  end
  always_ff @(posedge clk, negedge rstn) begin
    if (!rstn) p_o    <= '0;
    else if (v_q) p_o <= p_10;
  end

endmodule
