module compressor4_2 (
    input  logic [3:0] a_i,
    input  logic       c_i,
    output logic [1:0] s_o,
    output logic       c_o
);
  logic p1;
  logic p2;
  logic s1;

  assign p1 = ^a_i[1:0];
  assign p2 = ^a_i[3:2];
  assign s1 = p1 ^ p2;

  assign c_o = p1 ? a_i[2] : a_i[0];

  assign s_o[1] = s1 ? c_i : a_i[3];
  assign s_o[0] = s1 ^ c_i;

endmodule
