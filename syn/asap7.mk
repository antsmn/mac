
export TECH_LIB_DIR = /Users/antoniosimone/h/asap7sc7p5t/LIB/NLDM
export TECH_LIB     = $(shell ls $(TECH_LIB_DIR)/*_RVT_TT*)
export TECH_LIB_FF  = $(shell ls $(TECH_LIB_DIR)/*_RVT_FF*)
export TECH_LIB_SS  = $(shell ls $(TECH_LIB_DIR)/*_RVT_SS*)

export DONT_USE_CELLS = A2O1A* O2A1O* OR* AND*
export TECH_MAP_FILES = techmap_fa2.v

export MIN_BUF_CELL_AND_PORTS = BUFx2_ASAP7_75t_R A Y
export TIEHI_CELL_AND_PORT    = TIEHIx1_ASAP7_75t_R H
export TIELO_CELL_AND_PORT    = TIELOx1_ASAP7_75t_R L
