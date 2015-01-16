.DEFAULT_GOAL := test
.PHONY: test

gem:
	gem build *.gemspec

test:
	cutest test/*.rb
