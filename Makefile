test:
	find tests -type f -name '*.yaml' | parallel -j 10 -k --bar ./test-template.sh {}

test-template:
	./test-template.sh $(TEMPLATE)