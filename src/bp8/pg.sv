module pg
  import pg_pkg::*;
(
    input  logic                  a_signed_i,
    input  logic                  b_signed_i,
    input  logic                  c_signed_i,
    input  logic [W-1:0]          a_i,
    input  logic [W-1:0]          b_i,
    input  logic [W-1:0]          c_i,
    output logic [K-1:0][2*W-1:0] p_o
);

  logic a_sign;
  logic b_sign;
  logic c_sign;

  assign a_sign = a_signed_i & a_i[W-1];
  assign b_sign = b_signed_i & b_i[W-1];
  assign c_sign = c_signed_i & c_i[W-1];

  logic [BTH_W-1:0] a;

  assign a = ({{(BTH_W - W) {a_sign}}, a_i});

  // cpa size for partially redundant PP
  // cpa num blocks N = W / E must be integer, e.g 16 / 8 = 2
  // localparam E = 16;
  localparam E = 8;
  // localparam E = 4;

  logic [BTH_W-1:0] a1_i;
  logic [BTH_W-1:0] a2_i;
  logic [BTH_W-1:0] a3_i;
  logic [BTH_W-1:0] a4_i;
  logic [BTH_W-1:0] y1_i;
  logic [BTH_W-1:0] y2_i;
  logic [BTH_W-1:0] y3_i;
  logic [BTH_W-1:0] y4_i;

  pg_a3 #(.W(BTH_W), .E(E)) i_pg_a3 (.a_i(a), .p_o(a3_i), .y_o(y3_i));
  pg_a1 #(.W(BTH_W), .E(E)) i_pg_a1 (.a_i(a), .p_o(a1_i), .y_o(y1_i));
  pg_a1 #(.W(BTH_W), .E(E)) i_pg_a2 (.a_i(a << 1), .p_o(a2_i), .y_o(y2_i));
  pg_a1 #(.W(BTH_W), .E(E)) i_pg_a4 (.a_i(a << 2), .p_o(a4_i), .y_o(y4_i));

  // bias k
  logic [BTH_W-1:0] k_i;
  wire              one = 1'b1; // sensitivity to always comb for bias k
  always @(*) begin
    k_i = '0;
    for (int i = E + 1; i < BTH_W - 1; i += E) k_i[i] = one;
  end
  // C compensation constant
  // Σ( -k )
  logic [2*W-1:0] cc;

  always@(*) begin
    cc = '0;
    for (int i = 0; i < BTH_K; i += 1) cc -= (k_i << (3 * i));
  end

  logic [BTH_X-1:0] b;

  assign b = ({{(BTH_X - W - 1) {b_sign}}, b_i, 1'b0});

  logic [BTH_K-1:0][3:0] x;

  logic [BTH_K-1:0][BTH_W-1:0] p;
  logic [BTH_K-1:0][BTH_W-1:0] y;
  logic [BTH_K-1:0]            n;
  logic [BTH_K-1:0]            e;

  for (genvar i = 0; i < BTH_K; i += 1) begin
    assign x[i] = b[3*i+:4];
    be #(.W(BTH_W), .E(E)) i_be (.*, .x_i(x[i]), .p_o(p[i]), .y_o(y[i]), .n_o(n[i]));

    assign e[i] = a_signed_i ? p[i][BTH_W-1] : n[i];

  end
  always @(*) begin

    p_o = '0;
    p_o[0] = {~e[0], e[0], e[0], e[0], p[0]};

    for (int i = 1; i < BTH_K; i += 1) p_o[i] = {2'b11, ~e[i], p[i], 2'b00, n[i-1]} << (3 * (i - 1));
    p_o[K-4] = n[BTH_K-1] << (3 * (BTH_K - 1));

    p_o[K-3] = {{W {c_sign}}, c_i};

    // for this merge shift cpa size must be relatively prime to the shift amount (BTH_K < 2 * E)
    // 1 row for merged y every E rows
    // for (int i = 0; i < BTH_K; i += 1) p_o[K-2] += (y[i] << (3 * i));
    for (int i = 0; i < BTH_K; i += 1) p_o[K-2] = p_o[K-2] | (y[i] << (3 * i));

    // C compensation constant
    // Σ( -k )
    p_o[K-1] = cc;

  end

endmodule
