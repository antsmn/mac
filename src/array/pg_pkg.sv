package pg_pkg;
`ifndef W
  // TODO make this invalid
  parameter W = 16;
`else
  parameter W = `W;
`endif
  localparam K = W + 3;

endpackage
