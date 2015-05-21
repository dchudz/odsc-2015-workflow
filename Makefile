MODELS := rf lm

define make-model-targets

working/models/$(MODEL)/predicted_vs_actual.png: scripts/plot_predicted_vs_actual.R working/models/$(MODEL)/test_predictions.csv
	Rscript $$^ $$@

working/models/$(MODEL)/test_predictions.csv: scripts/model.R input/train.csv input/test.csv
	Rscript $$^ $(MODEL) $$@

working/models/model_performance.png: working/models/$(MODEL)/test_predictions.csv

actual-vs-predicted: working/models/$(MODEL)/predicted_vs_actual.png

residuals-app: working/models/$(MODEL)/test_predictions.csv

endef

$(foreach MODEL,$(MODELS),$(eval $(call make-model-targets,$MODEL)))

working/models/model_performance.png: scripts/model_performance.R
	Rscript $(firstword $^) "$(wordlist 2, $(words $^), $^)" $@

all: working/models/model_performance.png actual-vs-predicted

.PHONY: all actual-vs-predicted residuals-app

residuals-app:
	Rscript launch_app.R residuals "$^"




## Commented this out for now b/c I'm pretending `input/` is actually the input.
## (Simplifying the fact that there are steps to create that)

# original_working/cleaned_input.csv: original_input/Train.csv original_input/Machine_Appendix.csv scripts/clean.R
# 	Rscript scripts/clean.R $@ $^

# input/_: original_working/cleaned_input.csv scripts/train_test_split.R
# 	Rscript scripts/train_test_split.R $@ $^
# 	touch $@

# input/train.csv: input/_
# input/test.csv: input/_

reveal: reveal.js/output/whats_make.png reveal.js/output/bulldozer_graph_1.png reveal.js/output/predicted_vs_actual.png

reveal.js/output/whats_make.png:
	cd whats_make && make final_output -Bnd | make2graph | dot -Tpng -o ../reveal.js/output/whats_make.png

reveal.js/output/bulldozer_graph_predicted_vs_actual.png:
	make actual-vs-predicted -Bnd | make2graph | dot -Tpng -o $@

reveal.js/output/predicted_vs_actual.png: working/predicted_vs_actual.png
	cp $^ $@

reveal.js/output/model_performance.png: working/models/model_performance.png
	cp $^ $@
	

reveal.js/output/bulldozer_graph_actual_vs_predicted.png:
	make actual-vs-predicted -Bnd | make2graph | dot -Tpng -o $@

reveal.js/output/bulldozer_graph_model_performance.png:
	make working/models/model_performance.png -Bnd | make2graph | dot -Tpng -o $@

reveal.js/output/bulldozer_graph_all.png:
	make all -Bnd | make2graph | dot -Tpng -o $@

graphs: reveal.js/output/bulldozer_graph_all.png reveal.js/output/bulldozer_graph_model_performance.png reveal.js/output/bulldozer_graph_predicted_vs_actual.png