working/predicted_vs_actual.png: scripts/plot_predicted_vs_actual.R working/test_predictions.csv
	Rscript $^ $@ 

working/test_predictions.csv: scripts/model.R input/train.csv input/test.csv
	Rscript $^ $@ 

## Commented this out for now b/c I'm pretending `input/` is actually the input.
## (Simplifying the fact that there are steps to create that)

# original_working/cleaned_input.csv: original_input/Train.csv original_input/Machine_Appendix.csv scripts/clean.R
# 	Rscript scripts/clean.R $@ $^

# input/_: original_working/cleaned_input.csv scripts/train_test_split.R
# 	Rscript scripts/train_test_split.R $@ $^
# 	touch $@

# input/train.csv: input/_
# input/test.csv: input/_


all: input/train_test_split/_

reveal: reveal.js/output/whats_make.png reveal.js/output/bulldozer_graph_1.png reveal.js/output/predicted_vs_actual.png

reveal.js/output/whats_make.png:
	cd whats_make && make final_output -Bnd | make2graph | dot -Tpng -o ../reveal.js/output/whats_make.png

reveal.js/output/bulldozer_graph_1.png:
	make working/predicted_vs_actual.png -Bnd | make2graph | dot -Tpng -o $@

reveal.js/output/predicted_vs_actual.png: working/predicted_vs_actual.png
	cp $^ $@

all: reveal.js/output/whats_make.png