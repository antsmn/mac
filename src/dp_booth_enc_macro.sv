//
// TSMC SAGE-XTM Standard Cell Library Databook
//
`default_nettype wire

module CMPR43 (A, B, C, D, ICI, ICO, S, CO);
  input  A;
  input  B;
  input  C;
  input  D;
  input  ICI;
  output ICO;
  output S;
  output CO;

  // The CMPR42 cell takes in 4 bits of the partial product (A, B, C, D) and compresses them into 2-bits of partial product (S, CO). The cell requires an intermediate carry-in input (ICI) from the n-1 compressor and an intermediate carry-out output (CO) to the n+1 compressor. The CMPR42 cell also contains an internal sum (IS). The internal sum (IS), carry-in output (ICO), and the two outputs (S, CO) are represented by the logic equations:

  assign IS = A ^ B ^ C;
  assign ICO = (A & B) | (A & C) | (B & C);
  assign S = IS ^ D ^ ICI;
  assign CO = (IS & D) | (IS & ICI) | (D & ICI);

  // .i 5
  // .o 3
  // .ilb ICI A B C D
  // .ob S CO ICO
  // 0000
  // 0001
  // 0010
  // 0011
  // 0100
  // 0101
  // 0110
  // 0111
  // 1000
  // 1001
  // 1010
  // 1011
  // 1100
  // 1101
  // 1110
  // 1111

endmodule

module BENCX1 (M0, M1, M2, S, A, X2);
  input  M0;
  input  M1;
  input  M2;
  output X2;
  output S;
  output A;

  // The booth encoder block (BENC) cell performs a 2-bit multiplier recoding per a modified Booth’s algorithm. Each BENC cell examines 3 bits of the multiplier (M0, M1, M2) and generates the appropriate control signals to adjust the multiplicand for subsequent partial product reduction. The outputs (S, A, X2) are represented by the logic equations:

  assign S = ~M2 & (M1 | M0);
  assign A  = M2 & (~M1 | ~M0);
  assign X2 = ~(M1 ^ M0);

  // .i 3
  // .o 3
  // .ilb M2 M1 M0
  // .ob X2 A S
  // .type fd
  // 000  -11
  // 001  001
  // 010  001
  // 011  101
  // 100  110
  // 101  010
  // 110  010
  // 111  -11

  // espresso < file >| file2

  // .i 3
  // .o 3
  // .ilb M2 M1 M0
  // .ob X2 A S
  // -00 110
  // -11 101
  // 1-- 010
  // 0-- 001

  // espresso -Dso -oeqntott < file2

  // X2 = (!M1&!M0) | (M1&M0);
  // A = (!M1&!M0) | (M2);
  // S = (M1&M0) | (!M2);

endmodule

module BMXX1 (M0, M1, S, A, X2, PP);
  input  M0;
  input  M1;
  output PP;
  input  X2;
  input  S;
  input  A;

  // The BMX cell performs the shifting and 2’s complement inversion of the multiplicand bits (M1 and M0) based on the recode control signals (X2, A, and S) from the BENC cell. The partial product output (PP) is represented by the logic equation:

  assign PP = (X2 & ((M0 & ~A) | (~M0 & ~S))) | (~X2 & ((M1 & ~A) | (~M1 & ~S)));

endmodule
