module counter5_3 (
    input  logic [4:0] a_i,
    output logic [2:0] s_o
);
  // A.K. Verma and P.Ienne,"Automatic synthesis of compressor trees:
  // re-evaluating large counters", 2007

  logic [1:0] a1;
  logic [1:0] a0;
  logic       b1;
  logic       b0;
  logic [1:0] s1;
  logic [1:0] c1;
  logic       s2;
  logic       c2;

  assign a1 = a_i[4:3];
  assign a0 = a_i[1:0];

  ha i_ha_1 (.a_i(a1[1]), .b_i(a1[0]), .c_o(c1[1]), .s_o(s1[1]));
  ha i_ha_0 (.a_i(a0[1]), .b_i(a0[0]), .c_o(c1[0]), .s_o(s1[0]));

  assign b0 = s1[0];
  assign b1 = s1[1];

  ha i_ha_2 (.a_i(b0), .b_i(b1), .c_o(c2), .s_o(s2));

  // make two carries from top 3 input bits and bottom 3 input bits

  logic [1:0] c3;

  assign c3[1] = ((a_i[4] & a_i[3]) |
                  (a_i[4] & a_i[2]) |
                  (a_i[3] & a_i[2]) );
  assign c3[0] = ((a_i[2] & a_i[1]) |
                  (a_i[2] & a_i[0]) |
                  (a_i[1] & a_i[0]) );

  assign s_o[2] = (c3[0] & c1[1]) |
                  (c3[1] & c1[0]);
  assign s_o[1] = (^c3) | c2;
  assign s_o[0] = a_i[2] ^ s2;

endmodule
