module counter8_4 (
    input  logic [7:0] a_i,
    output logic [3:0] s_o
);
  // N. Burgess and D. R. Lutz, "Experiments with synthesizing
  // multiplier reduction trees," 2012

  logic [3:0] s1;
  logic [3:0] c1;

  for (genvar i = 0; i < 4; i += 1) begin

    logic a;
    logic b;

    assign a = a_i[i*2];
    assign b = a_i[i*2+1];

    logic so;
    logic co;

    ha i_ha_0
    (
        .a_i(a),
        .b_i(b),
        .s_o(so),
        .c_o(co)
    );
    assign s1[i] = so;
    assign c1[i] = co;

  end

  logic [3:0] s2;
  logic [3:0] c2;

  for (genvar i = 0; i < 4; i += 2) begin

    logic a1;
    logic b1;

    assign a1 = s1[i];
    assign b1 = s1[i+1];

    logic so;
    logic co;

    ha i_ha_1
    (
        .a_i(a1),
        .b_i(b1),
        .s_o(so),
        .c_o(co)
    );
    assign s2[i] = so;
    assign c2[i] = co;

    logic a2;
    logic b2;

    assign a2 = c1[i];
    assign b2 = c1[i+1];

    logic ls2;
    logic lc2;

    ha i_ha_2
    (
        .a_i(a2),
        .b_i(b2),
        .s_o(ls2),
        .c_o(lc2)
    );
    assign s2[i+1] = ls2;
    assign c2[i+1] = lc2;

  end
  logic [1:0] o1;

  assign o1[1] = s2[3] | c2[2];
  assign o1[0] = s2[1] | c2[0];

  // rca

  logic s3;
  logic c3;
  logic s4;
  logic c4;
  logic s5;
  logic c5;

  ha i_ha_0 (.a_i(s2[2]), .b_i(s2[0]), .c_o(c3), .s_o(s3));
  fa i_fa_1 (.a_i(o1[1]), .b_i(o1[0]), .c_i(c3), .c_o(c4), .s_o(s4));
  fa i_fa_2 (.a_i(c2[3]), .b_i(c2[1]), .c_i(c4), .c_o(c5), .s_o(s5));

  assign s_o[3] = c5;
  assign s_o[2] = s5;
  assign s_o[1] = s4;
  assign s_o[0] = s3;

endmodule
