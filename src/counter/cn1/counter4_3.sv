module counter4_3 (
    input  logic [3:0] a_i,
    output logic [2:0] s_o
);
  // N. Burgess and D. R. Lutz, "Experiments with synthesizing
  // multiplier reduction trees," 2012

  logic m1;
  logic m2;
  logic o1;
  logic o2;

  assign m1 = (( a_i[3] & ~a_i[2] & ~a_i[1])
               | (~a_i[3] &  a_i[2] & ~a_i[1])
               | (~a_i[3] & ~a_i[2] &  a_i[1]));
  assign m2 = ((~a_i[3] &  a_i[2] &  a_i[1])
               | ( a_i[3] & ~a_i[2] &  a_i[1])
               | ( a_i[3] &  a_i[2] & ~a_i[1]));
  assign o1 = (m2 | m1);
  assign o2 = ((a_i[3] & a_i[2])
               | (a_i[2] & a_i[1])
               | (a_i[3] & a_i[1]));

  assign s_o[1] = a_i[0] ? o1 : o2;

  assign s_o[0] = ^a_i;
  assign s_o[2] = &a_i;

endmodule
