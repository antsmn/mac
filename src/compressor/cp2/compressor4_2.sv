module compressor4_2 (
    input  logic [3:0] a_i,
    input  logic       c_i,
    output logic [1:0] s_o,
    output logic       c_o
);
  // CMOS VLSI Design: A Circuits and Systems Perspective - Neil
  // H. E. Weste, David Money Harris Addison Wesley, 2011
  logic [1:0] s1;
  logic [1:0] c1;
  logic s2;
  logic c2;

  for (genvar i = 0; i < 2; i += 1) begin
    ha i1 (.a_i(a_i[2*i+1]), .b_i(a_i[2*i]), .c_o(c1[i]), .s_o(s1[i]));
  end
  assign c2  = (&c1) | (&s1);
  assign s2  = ^s1;
  assign s_o = {c2 | (s2 & c_i), s2 ^ c_i};
  assign c_o = |c1;

endmodule
