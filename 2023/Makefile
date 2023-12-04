CXX=clang++
CXXFLAGS=-std=gnu++20 -Wall -Wshadow-all

ifeq ($(FAST), 1)
	CXXFLAGS+=-O3
else
	CXXFLAGS+=-g
endif

%a.test: %a
	./test.sh $*a

%b.test: %b
	./test.sh $*b

%a.run: %a
	./$*a < $*.in

%b.run: %b
	./$*b < $*.in

%.in:
	curl -s 'https://adventofcode.com/2023/day/$(shell echo $* | sed s/^0//)/input' -H "Cookie: session=$$(cat cookie.txt)" > $@
