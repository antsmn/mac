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

  localparam X = K / 4;
  localparam Y = K - X * 3;

  logic [X-1:0][2*W-1:0] t0_a1;
  logic [X-1:0][2*W-1:0] t0_a2;
  logic [X-1:0][2*W-1:0] t0_a3;
  logic [Y-1:0][2*W-1:0] t0_a4;
  logic [  1:0][2*W-1:0] t0_p1;
  logic [  1:0][2*W-1:0] t0_p2;
  logic [  1:0][2*W-1:0] t0_p3;
  logic [  1:0][2*W-1:0] t0_p4;

  assign t0_a1 = p_0[1*X-1:0];
  assign t0_a2 = p_0[2*X-1:1*X];
  assign t0_a3 = p_0[3*X-1:2*X];
  assign t0_a4 = p_0[  K-1:3*X];

  csa #(X, 2 * W) i_csa_e1_1 (.p_i(t0_a1), .p_o(t0_p1));
  csa #(X, 2 * W) i_csa_e1_2 (.p_i(t0_a2), .p_o(t0_p2));
  csa #(X, 2 * W) i_csa_e1_3 (.p_i(t0_a3), .p_o(t0_p3));
  csa #(Y, 2 * W) i_csa_e1_4 (.p_i(t0_a4), .p_o(t0_p4));

  logic [ 1:0][2*W-1:0] t1_a1;
  logic [ 1:0][2*W-1:0] t1_a2;
  logic [ 1:0][2*W-1:0] t1_a3;
  logic [ 1:0][2*W-1:0] t1_a4;

  always_ff @(posedge clk, negedge rstn) begin
    if (!rstn) t1_a1 <= '0;
    else t1_a1 <= t0_p1;
  end
  always_ff @(posedge clk, negedge rstn) begin
    if (!rstn) t1_a2 <= '0;
    else t1_a2 <= t0_p2;
  end
  always_ff @(posedge clk, negedge rstn) begin
    if (!rstn) t1_a3 <= '0;
    else t1_a3 <= t0_p3;
  end
  always_ff @(posedge clk, negedge rstn) begin
    if (!rstn) t1_a4 <= '0;
    else t1_a4 <= t0_p4;
  end

  logic [ 7:0][2*W-1:0] t1_a;
  logic [ 1:0][2*W-1:0] t1_p;

  assign t1_a[0] = t1_a1[0];
  assign t1_a[1] = t1_a2[0];
  assign t1_a[2] = t1_a3[0];
  assign t1_a[3] = t1_a4[0];

  assign t1_a[7] = t1_a1[1] << 1;
  assign t1_a[6] = t1_a2[1] << 1;
  assign t1_a[5] = t1_a3[1] << 1;
  assign t1_a[4] = t1_a4[1] << 1;

  csa #(8, 2 * W) i_csa_e2_1 (.p_i(t1_a), .p_o(t1_p));

  logic [    1:0][2*W-1:0] t2_a;

  always_ff @(posedge clk, negedge rstn) begin
    if (!rstn) t2_a <= '0;
    else t2_a <= t1_p;
  end

  logic [ 2*W-1:0] t3_a;
  logic [ 2*W-1:0] t3_b;
  logic [ 2*W-1:0] t3_s;

  assign t3_a = t2_a[0];
  assign t3_b = t2_a[1] << 1;

  cpa #(2 * W) i_cpa_e2_1 (.a_i(t3_a), .b_i(t3_b), .s_o(t3_s));

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
    else if (v_q[1]) p_o <= t3_s;
  end

endmodule
