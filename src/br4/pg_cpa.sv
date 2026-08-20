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
  logic                        a_sign;
  logic                        b_sign;
  logic                        c_sign;

  assign a_sign = a_signed_i & a_i[W-1];
  assign b_sign = b_signed_i & b_i[W-1];
  assign c_sign = c_signed_i & c_i[W-1];

  logic [BTH_W-1:0]            a;
  logic [BTH_X-1:0]            b;

  assign a = {{(BTH_W - W) {a_sign}}, a_i};
  assign b = {{(BTH_X - W) {b_sign}}, b_i};

  logic [BTH_W-1:0]            a1_i;
  logic [BTH_W-1:0]            a2_i;

  assign a1_i = a;
  assign a2_i = a << 1;


  logic [BTH_K-1:0]            enc_p;
  logic [BTH_K-1:0]            enc_g;

  for (genvar i = 0; i < BTH_K; i += 1) begin
    assign {enc_g[i], enc_p[i]} = {b[2*i+1] & b[2*i], b[2*i+1]};
  end

  logic [BTH_K-1:0]            car_p;
  logic [BTH_K-1:0]            car_g;

  pg_tree #(BTH_K) i_pg_tree (.p_i(enc_p), .g_i(enc_g), .p_o(car_p), .g_o(car_g));

  wire [BTH_K-1:0]             car_g2 = car_g << 1;


  logic [BTH_K-1:0][BTH_W-1:0] p;
  logic [BTH_K-1:0]            n;
  logic [BTH_K-1:0]            e;

  for (genvar i = 0; i < BTH_K; i += 1) begin
    be #(BTH_W) i_be (.*, .x_i(b[2*i+:2]), .c_i(car_g2[i]), .p_o(p[i]), .n_o(n[i]));

    assign e[i] = a_signed_i ? p[i][BTH_W-1] : n[i];

  end
  always @(*) begin

    p_o = '0;
    for (int i = 1; i < BTH_K; i += 1) p_o[i] = ({1'b1, ~e[i], p[i], 1'b0, n[i-1]}) << (2 * (i - 1));

    p_o[K-1] = c_i;

    p_o[0] = {({~e[0], e[0], e[0], p[0][BTH_W-1]} - c_sign), p[0][BTH_W-2:0]};

  end

endmodule

module pg_tree #(
    parameter W
) (
    input  logic [W-1:0] p_i,
    input  logic [W-1:0] g_i,
    output logic [W-1:0] p_o,
    output logic [W-1:0] g_o
);
  assign {p_o, g_o} = {p_i & (p_o << 1 | 1'b1), g_i | p_i & (g_o << 1)};

endmodule
