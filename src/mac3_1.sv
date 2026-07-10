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

  logic [K-1:0][2*W-1:0] p_1;

  always_ff @(posedge clk, negedge rstn) begin
    if (!rstn) p_1 <= '0;
    else p_1       <= p_0;
  end

  localparam X = K / 2;
  localparam Y = K - X;

  logic [X-1:0][2*W-1:0] t0_a1;
  logic [Y-1:0][2*W-1:0] t0_a2;
  logic [  1:0][2*W-1:0] t0_p1;
  logic [  1:0][2*W-1:0] t0_p2;

  assign t0_a1 = p_1[X-1:0];
  assign t0_a2 = p_1[K-1:X];

  csa #(X, 2 * W) i_csa_e1_1 (.p_i(t0_a1), .p_o(t0_p1));
  csa #(Y, 2 * W) i_csa_e1_2 (.p_i(t0_a2), .p_o(t0_p2));

  logic [1:0][2*W-1:0] t1_a1;
  logic [1:0][2*W-1:0] t1_a2;

  always_ff @(posedge clk, negedge rstn) begin
    if (!rstn) t1_a1 <= '0;
    else t1_a1 <= t0_p1;
  end
  always_ff @(posedge clk, negedge rstn) begin
    if (!rstn) t1_a2 <= '0;
    else t1_a2 <= t0_p2;
  end

  logic [3:0][2*W-1:0] t1_a;
  logic [1:0][2*W-1:0] t1_p;

  assign t1_a[3] = t1_a1[0];
  assign t1_a[2] = t1_a2[0];
  assign t1_a[1] = t1_a1[1] << 1;
  assign t1_a[0] = t1_a2[1] << 1;

  csa #(4, 2 * W) i_csa_e2_1 (.p_i(t1_a), .p_o(t1_p));

  logic [2*W-1:0] t2_a;
  logic [2*W-1:0] t2_b;
  logic [2*W-1:0] t2_s;

  assign t2_a = t1_p[0];
  assign t2_b = t1_p[1] << 1;

  cpa #(2 * W) i_cpa_e2_1 (.a_i(t2_a), .b_i(t2_b), .s_o(t2_s));

  logic [ 1:0] v_q;

  always_ff @(posedge clk, negedge rstn) begin
    if (!rstn) v_q <= '0;
    else v_q       <= {v_q[0], v_i};
  end
  always_ff @(posedge clk, negedge rstn) begin
    if (!rstn) v_o <= '0;
    else v_o       <= v_q[1];
  end
  always_ff @(posedge clk, negedge rstn) begin
    if (!rstn) p_o       <= '0;
    else if (v_q[1]) p_o <= t2_s;
  end

endmodule
