CXX=clang++
CXXFLAGS=-std=gnu++23 -Wall

ifeq ($(FAST), 1)
	CXXFLAGS+=-O3
else
	CXXFLAGS+=-g
endif

# Make executables explicit targets, so that implicit rules with
# match-anything prerequisites (read: executables) work
SOURCES = $(wildcard ???.cpp)
$(SOURCES:.cpp=):

clean:
	rm $(SOURCES:.cpp=)

%.test: %
	./test.sh $*

all.test: $(SOURCES:.cpp=.test)

%.run: %
	./$* < $(subst a,,$(subst b,,$*)).in

all.run: $(SOURCES:.cpp=.run)

%.in:
	curl -s 'https://adventofcode.com/2025/day/$(shell echo $* | sed s/^0//)/input' -H "Cookie: session=$$(cat cookie.txt)" > $@

%.ff:
	firefox 'https://adventofcode.com/2025/day/$(shell echo $* | sed s/^0//)'
