package pg_pkg;
`ifndef W
  // TODO make this invalid
  parameter W = 16;
`else
  parameter W = `W;
`endif

  localparam W_PAD = W + W % 2;

  localparam BTH_W = W + 2;

  // booth-3 pad 3 MSB and 1 LSB for even W
  localparam BTH_X = W_PAD + 4;
  localparam BTH_K = (BTH_X - 1) / 3;

  localparam K = BTH_K + 4;

endpackage
