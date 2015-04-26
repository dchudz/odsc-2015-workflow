

## [Problem Example 1: Story of difficulty reproducing results in academia]

----

## [Problem Example 2: Personal story of difficulty reproducing results at Allstate]

----

## [Problem: Understanding where things came from is painful.)

(Show big dependency graph. Emphasize that it's often just in people's heads.)

----

## Problem: Friction in asking for details

You're at a meeting where someone presents some results. Do you bother asking for details? (Will that be taken as doubt/criticism?)

More likely to look into details (to build on or improve) if they're already open.

----

##  Problem: Hard to get up to speed on a new project

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


## Example R Script (fits a model from train & tests on 

## Move R script to makefile

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


# Make training it's own step

# Add step for variable importance [or partial plots?]

# Loop over feature sets, models

# [For output directories, use ".sentinel" files]?

mydir/.sentinel: 

Touch mydir/.sentinel at the end of every script

at bottom of R script:

touch_sentinel(mydir)

or should we handle this in the makefile?

makefile helper function

# Make-level parallelism

Advantages of doing the parallelism here:

- OS takes care of scheduling
- No need to learn anything about how to put parallelism in your code
- Easier debugging

# Inspecting write out intermediate files for debugging

For some things a database would be easier, but there's a simplicity to CSVs. Easy to look and them and see if something is wrong.

depends on the sort of data, of course.

# Assertions about results

RSCRIPT = Rscript

output.csv: input.csv
	$(RSCRIPT) evaluate_model.R

Replace 

RSCRIPT = Rscript

with 

RSCRIPT = (Ben's thing)



# Use of RMarkdown (etc.) for documents

Quick iteration b/c the computations are all done already

# config file


# Shiny 


# conttest for automatic rebuilds


# Input type assertions

in the Rscript:

args = get_command_args()
#input_file = args[1]

input_file = input_file(args[1])

num_splits = input_integer(args[2])



# Plugging in pieces to the dependency graph

Uncouple both your scripts and makefile code from the particular application at hand.

in the makefile that gets included:

assert that $(TRAIN_CSV) variable is defined

- do the include
- now you can do things like:

"make importance-charts"




# CI server: notifications that it broke

# CI server for sharing results

# Other

drake "branch"






## (Not part of presentation, this is just for my own reference)


should I discuss checking results into github (for easy side-by-side comparison)? 

https://team.kaggle.com/wiki/R
https://team.kaggle.com/wiki/Makefile.CodingStyle
