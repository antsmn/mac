module compressor5_2 (
    input  logic [4:0] a_i,
    input  logic [1:0] c_i,
    output logic [1:0] s_o,
    output logic [1:0] c_o
);
  // Ohsang Kwon, K. Nowka and E. E. Swartzlander, "A 16-bit x 16-bit
  // MAC design using fast 5:2 compressors," 2000
  logic [1:0] s1;
  logic [1:0] s2;
  logic c1;
  logic c2;

  assign s1[1] = ^a_i[4:3];
  assign s1[0] = ^a_i[2:1];
  assign c1 = (|a_i[4:3]) & (|a_i[2:1]);
  assign c2 = (&a_i[4:3]) | (&a_i[2:1]);
  assign s2[1] = ^s1;

  logic s3;
  logic c3;

  assign s2[0] = a_i[0] ^ c_i[0];
  assign c3 = s2[1] ? c_i[0] : c2;
  assign s3 = ^s2;

  logic [1:0] s4;

  assign s4[0] = s3 ^ c_i[1];
  assign s4[1] = s3 ? c_i[1] : a_i[0];
  assign s_o    = s4;
  assign c_o[1] = c3;
  assign c_o[0] = c1;

endmodule
