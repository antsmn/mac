module compressor9_2 (
    input  logic [8:0] a_i,
    input  logic [5:0] c_i,
    output logic [1:0] s_o,
    output logic [5:0] c_o
);
  // P. J. Song and G. De Micheli, "Circuit and architecture
  // trade-offs for high-speed multiplication," 1991

  logic [2:0] s1;
  logic [2:0] c1;
  logic [1:0] s2;
  logic [2:0] c2;

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

  logic [5:0] a;
  logic [2:0] b;

  assign {a, b} = {s1, c_i};

  compressor6_2 i_compressor6_2 (
      .a_i(a),
      .c_i(b),
      .s_o(s2),
      .c_o(c2)
  );

  assign {c_o, s_o} = {c1, c2, s2};

endmodule
