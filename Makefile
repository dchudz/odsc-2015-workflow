working/test_predictions.csv: scripts/model.R input/train.csv input/test.csv
	Rscript $^ $@

working/predicted_vs_actual.png: scripts/plot_predicted_vs_actual.R working/test_predictions.csv
	Rscript $^ $@ 

