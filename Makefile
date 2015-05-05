

reveal.js/output/whats_make.png:
	cd whats_make && make final_output -Bnd | make2graph | dot -Tpng -o ../reveal.js/output/whats_make.png