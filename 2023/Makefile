CXX=clang++
CXXFLAGS=-std=gnu++20 -Wall -Wshadow-all
T=t1

ifeq ($(FAST), 1)
	CXXFLAGS+=-O3
else
	CXXFLAGS+=-g
endif

SOURCES = $(wildcard *.cpp)
$(SOURCES:.cpp=):

%.test: %
	./$* < $(subst a,,$(subst b,,$*)).$T

%.run: %
	./$* < $(subst a,,$(subst b,,$*)).in

%.in:
	curl -s 'https://adventofcode.com/2023/day/$(shell echo $* | sed s/^0//)/input' -H 'Cookie: session=$(shell cat cookie.txt)' > $@
