CXX=clang++
CXXFLAGS=-std=gnu++20 -Wall -Wshadow-all

ifeq ($(FAST), 1)
	CXXFLAGS+=-O3
else
	CXXFLAGS+=-g
endif

# create explicit rules for all executables, because otherwise:
# - we get "No rule to make target" errors, because non-terminal match-anything
#   rules don't apply to implicit prerequisites
# - the executable gets cleaned up after X.run or X.test, as it would be an
#   intermediate file in that case
SOURCES = $(wildcard *.cpp)
$(SOURCES:.cpp=):

%.test: %
	@if [ -z "$$T" ]; then T=$$(echo $*.t*); fi; \
	for TESTFILE in $$T; do \
		if ! [ -e $$TESTFILE ]; then \
			echo no tests; \
			continue; \
		fi; \
		echo "./$* < $$TESTFILE"; \
		ANS=$$(./$* < $$TESTFILE); \
		echo "$$ANS"; \
		CMPFILE=$$(echo $$TESTFILE | sed 's/\.t\([0-9]\)\+$$/\.a\1/'); \
		if [ $$TESTFILE != $$CMPFILE ] && [ -e $$CMPFILE ]; then \
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
	curl -s 'https://adventofcode.com/2023/day/$(shell echo $* | sed s/^0//)/input' -H "Cookie: session=$$(cat cookie.txt)" > $@
