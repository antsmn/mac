# make verilog src for synthesis, convert packed array declared in generate-for to 1d array

.SUFFIXES:
.SUFFIXES: .v .sv

.sv.v:
	@sv2v -w out $<

out:
	@mkdir out

clean:
	@rm -rf out
