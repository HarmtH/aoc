CXX=clang++
CXXFLAGS=-std=gnu++20 -Wall -Wshadow-all

ifeq ($(FAST), 1)
	CXXFLAGS+=-O3
else
	CXXFLAGS+=-g
endif

%.test: %
	@if [ -z "$$T" ]; then T=$$(echo $*.t*); fi; \
	for test in $$T; do \
		if ! [ -e $$test ]; then \
			echo no tests; \
			continue; \
		fi; \
		echo "./$* < $$test"; \
		ANS=$$(./$* < $$test); \
		echo "$$ANS"; \
		CMPFILE=$$(echo $$test | sed s/\\.t/\\.a/); \
		if [ -e $$CMPFILE ]; then \
			CMPANS=$$(cat $$CMPFILE); \
			if [ "$$ANS" = "$$CMPANS" ]; then \
				echo pass; \
			else \
				echo fail: $$CMPANS; \
			fi; \
		else \
			echo no cmp file; \
		fi; \
	done

DAYNOPART = $(subst a,,$(subst b,,$*))
%.run: %
	./$* < ${DAYNOPART}.in

%.in:
	curl -s 'https://adventofcode.com/2023/day/$(shell echo $* | sed s/^0//)/input' -H 'Cookie: session=$(shell cat cookie.txt)' > $@
