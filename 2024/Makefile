%.test:
	./test.sh $*

%.run:
	./$*.rb < $(subst a,,$(subst b,,$*)).in

%.in:
	curl -s 'https://adventofcode.com/2024/day/$(shell echo $* | sed s/^0//)/input' -H "Cookie: session=$$(cat cookie.txt)" > $@
