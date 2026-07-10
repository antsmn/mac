
.SUFFIXES:
.SUFFIXES: .v .o .e .pla

.o.v:
	@abc -c "read_pla $<; st;dch -x; write_verilog $@"
	@cat $@
.pla.o:
	@espresso -Dso $< $@
.pla.e:
	@espresso -Dso -oeqntott $< $@
clean:
	@rm -f *.v
	@rm -f *.e
