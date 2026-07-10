module counter4_3 (
    input  logic [3:0] a_i,
    output logic [2:0] s_o
);
  // A.K. Verma and P.Ienne,"Automatic synthesis of compressor trees:
  // re-evaluating large counters", 2007

  logic [1:0] a1;
  logic [1:0] a2;
  logic [1:0] s1;
  logic [1:0] c1;

  assign a1 = a_i[3:2];
  assign a2 = a_i[1:0];

  ha i_ha_1 (.a_i(a1[1]), .b_i(a1[0]), .c_o(c1[1]), .s_o(s1[1]));
  ha i_ha_0 (.a_i(a2[1]), .b_i(a2[0]), .c_o(c1[0]), .s_o(s1[0]));

  logic c2;
  assign c2     = &s1;

  assign s_o[2] = &c1;
  assign s_o[1] = (^c1) | c2;
  assign s_o[0] = ^s1;


endmodule
