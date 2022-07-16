# Advent of Code 2016

* [Day 1: No Time for a Taxicab](days/01)
* [Day 2: Bathroom Security](days/02)
* [Day 3: Squares With Three Sides](days/03)
* [Day 4: Security Through Obscurity](days/04)
* [Day 5: How About a Nice Game of Chess?](days/05)
* [Day 6: Signals and Noise](days/06)
* [Day 7: Internet Protocol Version 7](days/07)
* [Day 8: Two-Factor Authentication](days/08)
* [Day 9: Explosives in Cyberspace](days/09)
* [Day 10: Balance Bots](days/10)
* [Day 11: Radioisotope Thermoelectric Generators](days/11)
* [Day 12: Leonardo's Monorail](days/12)
* [Day 13: A Maze of Twisty Little Cubicles](days/13)
* [Day 14: One-Time Pad](days/14)
* [Day 15: Timing is Everything](days/15)
* [Day 16: Dragon Checksum](days/16)
* [Day 17: Two Steps Forward](days/17)
* [Day 18: Like a Rogue](days/18)
* [Day 19: An Elephant Named Joseph](days/19)

## Setup Notes

Install a version of Elixir that matches the constraint in `mix.exs` (or use
`asdf install` to get the exact versions of Elixir and Erlang/OTP I last tested
with), then run `mix test`.

Some CPU-intensive tests are not run by default. Use `mix test --include slow`
to include them, though note this can take several minutes to complete.
