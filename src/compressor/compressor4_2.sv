module compressor4_2 (
    input  logic [3:0] a_i,
    input  logic       c_i,
    output logic [1:0] s_o,
    output logic       c_o
);
  logic s1;
  logic c1;
  logic s2;
  logic c2;

  fa i_fa1 (.a_i(a_i[3]), .b_i(a_i[2]), .c_i(a_i[1]), .s_o(s1), .c_o(c1));
  fa i_fa2 (.a_i(a_i[0]), .b_i(c_i), .c_i(s1), .s_o(s2), .c_o(c2));

  assign c_o = c1;
  assign s_o[1] = c2;
  assign s_o[0] = s2;

endmodule
