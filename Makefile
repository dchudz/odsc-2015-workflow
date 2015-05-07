
working/cleaned_input.csv: input/Train.csv input/Machine_Appendix.csv scripts/clean.R
	Rscript scripts/clean.R $@ $^

working/train_test_split/_: working/cleaned_input.csv scripts/train_test_split.R
	Rscript scripts/train_test_split.R $@ $^
	touch $@

all: working/train_test_split/_

reveal.js/output/whats_make.png:
	cd whats_make && make final_output -Bnd | make2graph | dot -Tpng -o ../reveal.js/output/whats_make.png

all: reveal.js/output/whats_make.png