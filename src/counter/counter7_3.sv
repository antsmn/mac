module counter7_3 (
    input  logic [6:0] a_i,
    output logic [2:0] s_o
);
  logic [1:0] s1;
  logic [1:0] c1;

  for (genvar i = 0; i < 2; i += 1) begin

    logic a;
    logic b;
    logic c;

    assign a = a_i[i*3];
    assign b = a_i[i*3+1];
    assign c = a_i[i*3+2];

    logic so;
    logic co;

    fa i_fa (
        .a_i(a),
        .b_i(b),
        .c_i(c),
        .s_o(so),
        .c_o(co)
    );
    assign s1[i] = so;
    assign c1[i] = co;

  end

  logic s2;
  logic c2;

  fa i_fa1 (.a_i(a_i[6]), .b_i(s1[1]), .c_i(s1[0]), .c_o(c2), .s_o(s2));

  logic s3;
  logic c3;

  fa i_fa2 (.a_i(c2), .b_i(c1[1]), .c_i(c1[0]), .c_o(c3), .s_o(s3));

  assign s_o[0]   = s2;
  assign s_o[2:1] = {c3, s3};

endmodule
