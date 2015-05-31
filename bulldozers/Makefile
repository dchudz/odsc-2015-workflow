all: working/models/model_performance.png actual-vs-predicted
.PHONY: all actual-vs-predicted residuals-app

working/cleaned_input.csv: input/Train.csv input/Machine_Appendix.csv scripts/clean.R
	Rscript scripts/clean.R $@ $^

# make deals with single file targets, but this script created 2 files, 
# "test" and "train". To hack around this, we use a file "_" in the "split" directory
# Search for "makefile directory sentinel files" for more info.
working/split/_: working/cleaned_input.csv scripts/train_test_split.R
	Rscript scripts/train_test_split.R $@ $^
	touch $@

working/split/train.csv: working/split/_
	touch $@

working/split/test.csv: working/split/_
	touch $@


MODELS := rf lm

define make-model-targets

working/models/$(MODEL)/predicted_vs_actual.png: scripts/plot_predicted_vs_actual.R working/models/$(MODEL)/test_predictions.csv
	Rscript $$^ $$@

working/models/$(MODEL)/test_predictions.csv: scripts/model.R working/split/train.csv working/split/test.csv
	Rscript $$^ $(MODEL) $$@

working/models/model_performance.png: working/models/$(MODEL)/test_predictions.csv

actual-vs-predicted: working/models/$(MODEL)/predicted_vs_actual.png

residuals-app: working/models/$(MODEL)/test_predictions.csv

endef


$(foreach MODEL,$(MODELS),$(eval $(call make-model-targets,$MODEL)))

working/models/model_performance.png: scripts/model_performance.R
	Rscript $(firstword $^) "$(wordlist 2, $(words $^), $^)" $@

residuals-app:
	Rscript launch_app.R residuals "$^"


