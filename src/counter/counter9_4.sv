module counter9_4 (
    input  logic [8:0] a_i,
    output logic [3:0] s_o
);
  logic [2:0] s1;
  logic [2:0] c1;

  for (genvar i = 0; i < 3; i += 1) begin

    logic a;
    logic b;
    logic c;

    assign a = a_i[i*3];
    assign b = a_i[i*3+1];
    assign c = a_i[i*3+2];

    logic so;
    logic co;

    fa i_fa
    (
        .a_i(a),
        .b_i(b),
        .c_i(c),
        .s_o(so),
        .c_o(co)
    );

    assign s1[i] = so;
    assign c1[i] = co;

  end

  logic a;
  logic b;
  logic c;

  assign a = s1[2];
  assign b = s1[1];
  assign c = s1[0];

  logic s2;
  logic c2;

  fa i_fa
  (
      .a_i(a),
      .b_i(b),
      .c_i(c),
      .s_o(s2),
      .c_o(c2)
  );

  logic [2:0] s3;
  logic [3:0] c3;

  assign c3 = {c1, c2};

  counter4_3 i_counter4_3 (.a_i(c3), .s_o(s3));

  assign s_o[0]   = s2;
  assign s_o[3:1] = s3;

endmodule
