module compressor5_2 (
    input  logic [4:0] a_i,
    input  logic [1:0] c_i,
    output logic [1:0] c_o,
    output logic [1:0] s_o
);
  logic [1:0] s1;
  logic [1:0] c1;
  logic s2;
  logic c2;

  fa i_fa1 (.a_i(a_i[4]), .b_i(a_i[3]), .c_i(a_i[2]), .c_o(c1[1]), .s_o(s1[1]));
  fa i_fa2 (.a_i(a_i[1]), .b_i(a_i[0]), .c_i(s1[1]), .c_o(c1[0]), .s_o(s1[0]));
  fa i_fa3 (.a_i(c_i[0]), .b_i(c_i[1]), .c_i(s1[0]), .s_o(s2), .c_o(c2));

  assign c_o = c1;
  assign s_o[1] = c2;
  assign s_o[0] = s2;

endmodule
