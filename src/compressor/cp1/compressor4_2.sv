module compressor4_2 (
    input  logic [3:0] a_i,
    input  logic       c_i,
    output logic [1:0] s_o,
    output logic       c_o
);
  // Ohsang Kwon, K. Nowka and E. E. Swartzlander, "A 16-bit x 16-bit
  // MAC design using fast 5:2 compressors," 2000
  logic [1:0] s1;
  logic [1:0] c1;
  logic s2;
  logic c2;
  logic c3;

  for (genvar i = 0; i < 2; i += 1) begin
    ha i1 (.a_i(a_i[2*i+1]), .b_i(a_i[2*i]), .c_o(c1[i]), .s_o(s1[i]));
  end
  assign c2 = |c1;

  assign c3 = (|a_i[3:2]) & (|a_i[1:0]);
  assign s2 = ^s1;

  logic [1:0] s3;

  assign s3[0] = s2 ^ c_i;
  assign s3[1] = s2 ? c_i : c2;
  assign s_o   = s3;
  assign c_o   = c3;

endmodule
