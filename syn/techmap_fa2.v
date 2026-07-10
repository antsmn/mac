module \$fa (A, B, C, X, Y);
  parameter WIDTH = 1;
  input  [WIDTH-1:0] A;
  input  [WIDTH-1:0] B;
  input  [WIDTH-1:0] C;
  output [WIDTH-1:0] X;
  output [WIDTH-1:0] Y;

  wire [WIDTH-1:0] NX;
  wire [WIDTH-1:0] NY;

  genvar i;

  for (i = 0; i < WIDTH; i = i + 1) begin : w

    FAx1_ASAP7_75t_R u (.A(A[i]), .B(B[i]), .CI(C[i]), .CON(NX[i]), .SN(NY[i]));
    assign X[i] = ~NX[i];
    assign Y[i] = ~NY[i];

  end

endmodule
