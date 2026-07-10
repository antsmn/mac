module \$fa (A, B, C, X, Y);
  parameter WIDTH = 1;
  input  [WIDTH-1:0] A;
  input  [WIDTH-1:0] B;
  input  [WIDTH-1:0] C;
  output [WIDTH-1:0] X;
  output [WIDTH-1:0] Y;

  wire [WIDTH-1:0]   T;

  genvar i;

  for (i = 0; i < WIDTH; i = i + 1) begin : w

    MAJx2_ASAP7_75t_R u1 (.Y(X[i]), .A(A[i]), .B(B[i]), .C(C[i]));
    XOR2x1_ASAP7_75t_R u2 (.Y(T[i]), .A(A[i]), .B(B[i]));
    XOR2x1_ASAP7_75t_R u3 (.Y(Y[i]), .A(T[i]), .B(C[i]));

  end

endmodule
