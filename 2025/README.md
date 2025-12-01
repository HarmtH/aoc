# Advent of Code 2025 in C++

## How to run

- Put your session cookie (without the session= part) in cookie.txt.
- Use `make 01.in` to get the input data.
- Use `make 01a.run` to get the answer to part 1.
- Use `make 01b.run` to get the answer to part 2.
- Add `FAST=1` to create an optimized build.
- Thus `make FAST=1 01a.run 01b.run` will give you both answers fast.

## How to test

- Copy tests to `01a.t1`, `01a.t2`, etc.
- If desired copy solutions to `01a.a1`, `01a.a2`, etc.
- Run `make 01a.test`.
- You can select a single test by adding `T=01a.t1`.
- So `make T=01a.t12 01a.test` tests only `01a.t12`.
- For part 2 use `01b.t1`, `01b.t2`, etc.
