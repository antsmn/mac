#!/bin/sh

SRC_DIR=$(realpath ../src)
export SRC_DIR

filelist=$(mktemp)

cat << \EOF >$filelist
$(SRC_DIR)/fa.sv
$(SRC_DIR)/ha.sv
$(SRC_DIR)/compressor.sv
$(SRC_DIR)/csa.sv
EOF

make NETLIST="csa.v" OUT_DIR="../netlist/csa8" VLOG_PARAMS="K=8 W=16" VLOG_TOP=csa VLOG_FLIST=$filelist YOSYS_FLAGS="" synth sta

rm $filelist
