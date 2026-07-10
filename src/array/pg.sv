module pg
  import pg_pkg::*;
(
    input logic a_signed_i,
    input logic b_signed_i,
    input logic c_signed_i,

    input  logic [W-1:0]          a_i,
    input  logic [W-1:0]          b_i,
    input  logic [W-1:0]          c_i,
    output logic [K-1:0][2*W-1:0] p_o
);
  logic [W-1:0][W-1:0] n_mask;
  logic                c_se;

  assign c_se = c_signed_i & c_i[W-1];

  always @(*) begin

    p_o = '0;
    for (int i = 0; i < W; i += 1) p_o[i] = (n_mask[i] ^ (a_i & {W{b_i[i]}})) << i;

    p_o[K-3]        = {{W{c_se}}, c_i};

    // fix large fanout on c sign extension with constant string 1'b1
    // p_o[K-3]     = {{W{1'b1}}, c_i};
    // p_o[K-2][W]  = ~c_se;

    p_o[K-2][2*W-1] = a_signed_i | b_signed_i;
    p_o[K-2][W-1]   = a_signed_i;
    p_o[K-1][W-1]   = b_signed_i;

  end

  assign n_mask[W-1] = {a_signed_i ^ b_signed_i, {(W - 1) {b_signed_i}}};

  for (genvar i = 0; i < W - 1; i += 1) assign n_mask[i] = {a_signed_i, {(W - 1) {1'b0}}};

endmodule
