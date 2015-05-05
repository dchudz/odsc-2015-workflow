intermediate_output: input/input1 input/input2
	echo "We made an intermediate output" > intermediate_output

final_output: intermediate_output
	cp intermediate_output final_output && echo "...and then we made the final output." >> final_output

LIST = 0 1 2 3 4 5
define make-example-target
working/example$1:
	echo "$1" > working/example$1
all: working/example$1
endef

$(foreach l,$(LIST),$(eval $(call make-example-target,$l)))