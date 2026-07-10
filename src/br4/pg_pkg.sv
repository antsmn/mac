package pg_pkg;
`ifndef W
  // TODO make this invalid
  parameter W = 16;
`else
  parameter W = `W;
`endif

  localparam W_PAD = W + W % 2;

  localparam BTH_W = W + 1;

  // booth-2 pad 2 MSB and 1 LSB for even W
  localparam BTH_X = W_PAD + 3;
  localparam BTH_K = BTH_X / 2;

  localparam K = BTH_K + 1;

endpackage
