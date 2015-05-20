Outline

0. I'm going to tell you:
	- (quickly) why it's a problem that data scientists often aren't automating their analysis pipelines
	- show one approach to automating pipelines 
1. the problem
2. What experience am I drawing on? (briefly describe the team Kaggle had working on oil & gas)
3. Broad overview of what makes a good process
4. What's make?
5. Use example to demonstrate key ideas:
	- Getting started with a makefile
		- initial script fits a model and evaluates it on test set
	- Motivation for breaking into 2 steps: Want to adjust scoring metric w/o 
	- Break train/test into 2 steps
	- Add more metrics to test script (starting interactively)
		+ test script producers a chart showing metrics for each model
	- Loop over models (show off parallel execution)
	- Add step for partial plots (starting interactively)
	- Show how to reuse partial plot makefile code
	- Navigating so many results is hard - using Shiny app
6. Combatting brittleness by surfacing errors: 
	- Helper functions to make assertions about input types
	- Assertions about expected results
	- CI server
	- use of hipchat w/ CI server


----



<h2>
	Data Workflows for:
	<ul style="list-style: none;">
		<li>Iteration</li>
		<li>Collaboration</li>
		<li>Reproducibility</li>
	</ul>
</h2>
<p>
	<small>
		<a href="http://davidchudzicki.com.com">David Chudzicki (Kaggle)</a>
		/
		<a href="http://twitter.com/dchudz">@dchudz</a>
	</small>
</p>

Note:

For other data scientists to improve, build on, or even just trust your analysis, they need to be able to reproduce it. Even if you have shared code and data, reproducing your analysis may be difficult: which code was executed against which data in what order? And even if the steps are clear, rerunning downstream steps to see your new results after changes upstream can be a tedious process.

This talk will demonstrate the workflow and tools we used to increase our productivity and enjoyment by reducing grunt work and making it easier to build on each other's work. We used GNU Make as a clear way to represent what each step does, the inputs it depends on, and the output it produces. As we iterate on our analysis, makefiles allow us to conveniently execute only the steps that depend on code or other inputs that have changed since the last run. I'll walk through an example of creating a project, adding each step as a modular script, and reusing these scripts in different contexts. Since interactive exploration (and debugging) is a big part of data science, I'll demonstrate techniques for conveniently going back and forth between batch execution via makefiles and working interactively. 

----

## Kaggle

Note: 

Also did consulting

--

## Informal data pipeline

[picture of someone asking someone something]

--

## Difficult to join project

[picture of someone confused]

--

## Automated pipeline

[picture of happy people?]

Note:

Mostly will talk about how we appproached automating the pipeline, but first I want to talk about some of the other problems this approach addresses.

----

## Reproducibility

Reinhart & Rogoff

--

> A well-known study completed by economists Ken Rogoff and Carmen Reinhart confirms this common-sense conclusion. 

> <cite>2013 Republican Budget Proposal</cite>

--

![](http://www.washingtonpost.com/blogs/wonkblog/files/2013/04/reinhart_rogoff_coding_error_0.png)

--

> What should I do if I cannot reproduce experimental published results?
> 
> <cite>[StackExchange Question](https://academia.stackexchange.com/questions/20640/what-should-i-do-if-i-cannot-reproduce-experimental-published-results)</cite>

<div></div>

> ...trying to get exact agreement also on the details that they didn't describe in the original paper...
> 
> <cite>(Accepted Answer)</cite>

--

![](images/reproduce_quickly.png)


Note: 

https://academia.stackexchange.com/questions/10096/how-to-replicate-others-results-quickly


--

(Personal story of difficulty reproducing results at when I worked at an insurance company)

--

Old code doesn't work anymore

--


## Where did these results come from?

(Understanding where things came from is painful.)

- (Show big dependency graph. Emphasize that it's often just in people's heads.)

--

## Might not bother asking for details

Do you bother asking for details? (Will that be taken as doubt/criticism?)

More likely to look into details (to build on or improve) if they're already open.

--

## Slow iteration

Iterating is hard if executing downstream steps is tedious

----

## What makes a good process?

--

Explicit 

Note:

- What outputs can we build?
- How are those built? 

--

Automated

--

Build only what we ask for

--

Rebuild only when needed

--

Allow working interactively

--

Visualize output conveniently

--

## Rest of the talk:

- Individual scripts that each do one thing
- Tying these scripts to makefiles
- Conveniently going back and forth between: 
	- execution via makefile
	- interactive work
- Checks to make sure we notice when something unexpected happened
- How we made sure the code was run regularly

----

## Make

```makefile
intermediate_output: input/input1 input/input2
	echo "We made an intermediate output" > intermediate_output

final_output: intermediate_output
	cp intermediate_output final_output
	echo "...and then we made the final output." >> final_output
```

![](output/whats_make.png)

--

At the shell:

```shell
make final_output
```

![](output/whats_make.png)

----

## Example: Predict sale price of farm equipment

![](https://kaggle2.blob.core.windows.net/competitions/kaggle/3316/media/bulldozer.jpg)

--

```r
# read data
train <- read_csv("working/train_test_split/train.csv")
test <- read_csv("working/train_test_split/test.csv")

# process features
train <- process_features(train)
test <- process_features(test)

```

--

```r
# read data
train <- read_csv("working/train_test_split/train.csv")
test <- read_csv("working/train_test_split/test.csv")

# process features
train <- process_features(train)
test <- process_features(test)

# fit model
feature_names <- c("saledate", "YearMade", "HorsePower", "ProductGroupDesc")
rf <- randomForest(train[feature_names], train$SalePrice, ntree=10)

# make predictions
test$Predicted <- predict(rf, test[feature_names])

```

--

```r
# read data
train <- read_csv("working/train_test_split/train.csv")
test <- read_csv("working/train_test_split/test.csv")

# process features
train <- process_features(train)
test <- process_features(test)

# fit model
feature_names <- c("saledate", "YearMade", "HorsePower", "ProductGroupDesc")
rf <- randomForest(train[feature_names], train$SalePrice, ntree=10)

# make predictions
test$Predicted <- predict(rf, test[feature_names])
	
# generate plot
ggplot(test) + 
  geom_point(aes(x=SalePrice, y=Predicted), alpha=.03) + 
  ggtitle("Actual vs. Predicted Sale Price") +
  xlab("Actual Sale Price ($)") +
  ylab("Predicted Sale Price ($)") +
  scale_y_continuous(labels = comma, limits=range(test$SalePrice)) +
  scale_x_continuous(labels = comma, limits=range(test$SalePrice)) +
  coord_fixed()
```

--

<img src="output/predicted_vs_actual.png" height="400">
--

Makefile:

```makefile
working/predicted_vs_actual.png: scripts/model.R input/train.csv input/test.csv
	Rscript scripts/model.R input/train.csv input/test.csv
```

--

Makefile:

```makefile
working/predicted_vs_actual.png: scripts/model.R input/train.csv input/test.csv
	Rscript $^ $@
```

--

Makefile:

```makefile
working/predicted_vs_actual.png: scripts/model.R input/train.csv input/test.csv
	Rscript $^ $@
```

R:

```r
args <- command_args()
# args: 
# c("input/train.csv", "input/test.csv", n"working/predicted_vs_actual.png")

train <- read_csv(args[1])
test <- read_csv(args[2])
output_file <- args[3]
.
.
.

ggsave(filename = output_file, plot = actual_predicted_plot)
```

Shell:

```shell
make working/predicted_vs_actual.png
```

--

![](output/bulldozer_graph_1.png)

<img src="output/predicted_vs_actual.png" height="400">

----

- Want to tweak the chart
- Don't want to retrain the model with every change we make 

Solution:

- Make training a separate step so we don't have to repeat it to add a scoring metric.

--

```makefile
working/test_predictions.csv: scripts/model.R input/train.csv input/test.csv
	Rscript $^ $@ 
```

--

(Live demo):

- `git checkout two-make-steps-1`
- Create make step
- Open scoring script
- How do we run w/ the arguments? Execute make in command line w/ argument-printing
- Tweak interactively
- Run as make step
- (maybe demonstrate conttest?)

----

Loop over models

--

![](output/bulldozer_graph_predicted_vs_actual.png)

--

In `fit.R`, replace this:

```r
.
.
.

train       <- read_csv(args[1])
test        <- read_csv(args[2])
output_file <- args[3]

.
.
.

# fit model
feature_names <- c("saledate", "YearMade", "HorsePower", "ProductGroupDesc")
rf <- randomForest(train[feature_names], train$SalePrice, ntree=10)

.
.
.
```

--

... with:

```r
.
.
.

train       <- read_csv(args[1])
test        <- read_csv(args[2])
model_name  <- args[3]
output_file <- ensure_parent_directory_exists(args[4])

model <- source_eval("src/models.R", models[[model_name]])

.
.
.

# fit model
feature_names <- c("saledate", "YearMade", "HorsePower", "ProductGroupDesc")
fitted <- model$fit(train, "SalePrice", feature_names)
  
# make predictions
test$Predicted <- model$predict(fitted, test)


.
.
.

```

--

... with this:

```
.
.
.

args <- command_args_unless_interactive(c("input/train.csv", "input/test.csv", "rf_2_trees", "working/rf_2_trees/test_predictions.csv"))

train        <- read_csv(args[1])
test         <- read_csv(args[2])
model_name   <- args[3]
output_file  <- ensure_parent_directory_exists(args[4])

model <- source_eval("src/models.R", models[[model_name]])
.
.
.
```
	
--

```makefile
MODELS := rf lm

define make-model-targets

working/models/$(MODEL)/predicted_vs_actual.png: scripts/plot_predicted_vs_actual.R working/models/$(MODEL)/test_predictions.csv
	Rscript $$^ $$@

working/models/$(MODEL)/test_predictions.csv: scripts/model.R input/train.csv input/test.csv
	Rscript $$^ $(MODEL) $$@

actual-vs-predicted: working/models/$(MODEL)/predicted_vs_actual.png

endef

$(foreach MODEL,$(MODELS),$(eval $(call make-model-targets,$MODEL)))
```

![](output/bulldozer_graph_predicted_vs_actual.png)

--

(Demonstrate parallel make)


--

Random Forest actual vs. predicted:

<img src="working/models/rf/predicted_vs_actual.png" height="600">

--

Linear Model actual vs. predicted:

<img src="working/models/lm/predicted_vs_actual.png" height="600">

--
<img src="output/model_performance.png" height="600">
	
--

![](output/bulldozer_graph_model_performance.png)

--


```makefile
MODELS := rf lm

define make-model-targets

working/models/$(MODEL)/predicted_vs_actual.png: scripts/plot_predicted_vs_actual.R working/models/$(MODEL)/test_predictions.csv
	Rscript $$^ $$@

working/models/$(MODEL)/test_predictions.csv: scripts/model.R input/train.csv input/test.csv
	Rscript $$^ $(MODEL) $$@

working/models/model_performance.png: working/models/$(MODEL)/test_predictions.csv

actual-vs-predicted: working/models/$(MODEL)/predicted_vs_actual.png

endef

$(foreach MODEL,$(MODELS),$(eval $(call make-model-targets,$MODEL)))

working/models/model_performance.png: scripts/model_performance.R
	Rscript $(firstword $^) "$(wordlist 2, $(words $^), $^)" $@
```

--

```bash
Rscript \
	scripts/model_performance.R \
	"working/models/rf/test_predictions.csv working/models/lm/test_predictions.csv" \
	working/models/model_performance.png
```

--

In R:

```r
> args
[1] "working/models/rf/test_predictions.csv working/models/lm/test_predictions.csv" 
[2] "working/models/model_performance.png"

> prediction_paths <- pipeline_input_file_vector(args[1])
> prediction_paths
[1] "working/models/rf/test_predictions.csv" 
[2] "working/models/lm/test_predictions.csv"
```

--



----



## (Not part of presentation, this is just for my own reference)


should I discuss checking results into github (for easy side-by-side comparison)? 

https://team.kaggle.com/wiki/R
https://team.kaggle.com/wiki/Makefile.CodingStyle

Other resources:

https://www.youtube.com/watch?v=7B3n-5atLxM