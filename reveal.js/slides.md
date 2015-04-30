
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
7. Tradeoffs in representation of intermediate files: having CSVs to look at can help you debug
8. Combatting brittleness:
	- Helper functions to make assertions about input types
	- Assertions about expected results
	- CI server
	- use of hipchat w/ CI server
9. Alternatives to Make

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

(Story about difficulty reproducing results in academia)

----

(Personal story of difficulty reproducing results at Allstate)

----

(Understanding where things came from is painful.)

- (Show big dependency graph. Emphasize that it's often just in people's heads.)

----

(Friction in asking for details)

You're at a meeting where someone presents some results. Do you bother asking for details? (Will that be taken as doubt/criticism?)

More likely to look into details (to build on or improve) if they're already open.

----

(Hard to get up to speed on a new project)

----

## Problem: The code doesn't work anymore

----

##  Problem: Iterating is hard if executing downstream steps is tedious

Even if the code still runs, this is slow.

----


## My Experience

Kaggle -- mostly competitions. Did some consulting. Had these problems. 

Brought engineers into our data science process. They taught us a lot! 

----

## Rough Overview of Good Process

- explicit 
- automated
- build only the desired individual analyses and what they depend on
- rebuild only when necessary

----

## Rest of the talk outline


- Individual scripts that each do one thing
- Tying these scripts to makefiles
- Conveniently going back and forth between: 
	- execution via makefile
	- interactive work
- Checks to make sure we notice when something unexpected happened
- How we made sure the code was run regularly

## What's make?

Primarily used for compiling software from source dependencies.

```makefile

target: dependency1 dependency2
	[shell command to create output from inputs]

```

When we say `make definitive_plot.png`, make builds that target and everything needed to create it.


## Example R Script (fits a model w/ train.csv and evaluates w/ test.csv)

## Move R script to makefile

```makefile

working/score.txt: input/train.csv input/test.csv
	Rscript train_and_test.R score.csv train.csv test.csv

```

Aside:

(Show how to avoid repition in output/input names)

## Want to change the scoring function

Make training a separate step so we don't have to repeat it to add a scoring metric.

## Interactively Adjust Scoring  

```r
if (interactive) ...
```

## Partial Plots

Multiple slides:

- Want to do other things with the fitted model
	- predictions on new test sit
	- visualizations

# Start script interactively...

- pull out inputs into args
- if(interactive) { } (to support interactive work)
- refactor if(interactive) to: get_args_or_default
	+ assign default args for interactive use
	+ get args from make
	+ print args from make in copy/pastable form (for debugging)


## Add step for variable importance [or partial plots?]


## Reusing make code - Plugging in pieces to the dependency graph

Uncouple both your scripts and makefile code from the particular application at hand.

in the makefile that gets included:

assert that $(TRAIN_CSV) variable is defined

- do the include
- now you can do things like:

"make importance-charts"




Import from external makefile

## Loop over feature sets, models

(move each step to inside loop)



## [For output directories, use ".sentinel" files]?

```makefile
mydir/.sentinel: (dependencies)
	recipe
```

Need to update timestamp of `mydir/.sentinel` at the end of every script:

```r
touch_sentinel(mydir)
```

Could do this in recipe instead:

...

But doing it in the script has less duplication of code if we use the same script in multiple places.

## Make-level parallelism

(show off our loop)

Advantages of doing the parallelism here:

- OS takes care of scheduling
- No need to learn anything about how to put parallelism in your code
- Easier debugging

## config file

Move settings (models, feature sets, etc.) to `Config.mk`


## Intermediate outputs as CSV files makes inspecting them easy

For some things a database would be easier, but there's a simplicity to CSVs. Easy to look and them and see if something is wrong.

depends on the sort of data, of course.

## Input type assertions

In the Rscript:

args = get_command_args()
#input_file = args[1]

input_file = input_file(args[1])

num_splits = input_integer(args[2])



## Assertions about results

(incorporating checks that automatically run after each step)

Replace 

```makefile
RSCRIPT = Rscript
```

with 

```makefile
RSCRIPT = (Ben's thing)
```


## Use of RMarkdown (etc.) for documents

Tweaking visualizations etc. based on computations than are already done.


## conttest for automatic rebuilds

As soon as a change is made, rebuild.

```bash
conttest 'make report.html' .
```

(Build `report.html` every time there is a change in the current directory)



## Shiny 

Navigating static results becomes a pain. Expose results in an interactive fashion. Shiny is good for this.



## CI server: notifications that it broke

## CI server for sharing results



## Alternatives to Make



## (Not part of presentation, this is just for my own reference)


should I discuss checking results into github (for easy side-by-side comparison)? 

https://team.kaggle.com/wiki/R
https://team.kaggle.com/wiki/Makefile.CodingStyle
