# Advent of Code 2016

🏁 These solutions are **complete**!
See below for my [retrospective](#retrospective).


### Setup

No setup is needed beyond having Elixir installed.


### Commands

* Run the tests: `mix test`
* Include CPU-intensive tests: `mix test --include slow`
  _(can take several minutes to complete)_


### Solutions

&nbsp;                                                    | Completed
--------------------------------------------------------- | :--------:
[Day 1: No Time for a Taxicab](days/01)                   | 2018-12-14
[Day 2: Bathroom Security](days/02)                       | 2018-12-16
[Day 3: Squares With Three Sides](days/03)                |          "
[Day 4: Security Through Obscurity](days/04)              | 2018-12-17
[Day 5: How About a Nice Game of Chess?](days/05)         |          "
[Day 6: Signals and Noise](days/06)                       | 2018-12-21
[Day 7: Internet Protocol Version 7](days/07)             |          "
[Day 8: Two-Factor Authentication](days/08)               | 2018-12-22
[Day 9: Explosives in Cyberspace](days/09)                | 2018-12-26
[Day 10: Balance Bots](days/10)                           | 2019-01-03
[Day 11: Radioisotope Thermoelectric Generators](days/11) | 2019-02-02
[Day 12: Leonardo's Monorail](days/12)                    | 2019-02-21
[Day 13: A Maze of Twisty Little Cubicles](days/13)       | 2019-10-27
[Day 14: One-Time Pad](days/14)                           |          "
[Day 15: Timing is Everything](days/15)                   | 2022-06-11
[Day 16: Dragon Checksum](days/16)                        | 2022-07-09
[Day 17: Two Steps Forward](days/17)                      |          "
[Day 18: Like a Rogue](days/18)                           | 2022-07-10
[Day 19: An Elephant Named Joseph](days/19)               | 2022-07-16
[Day 20: Firewall Rules](days/20)                         | 2022-07-17
[Day 21: Scrambled Letters and Hash](days/21)             | 2022-07-21
[Day 22: Grid Computing](days/22)                         | 2022-07-27
[Day 23: Safe Cracking](days/23)                          | 2022-08-16
[Day 24: Air Duct Spelunking](days/24)                    | 2022-08-19
[Day 25: Clock Signal](days/25)                           | 2022-08-19


### Retrospective

The contrast between this event and the first is interesting — to me it felt
geared towards people who completed 2015 and wanted a greater challenge. At Day
10/11 the difficulty abruptly climbs to a level beyond anything in 2015, and
stays high from then on. More than once, I was still missing the key insight
for a puzzle after hours of head-scratching, and resorted to searching the
[subreddit] for hints. In retrospect it was good "exercise", but in the moment
it was sometimes more frustrating than I wanted from a fun free-time activity.

Elixir was fairly new to me when I started this event, and turned out to be a
great fit. Erlang's expansive standard library came in handy several times,
with [`digraph`][digraph] saving a lot of work on one puzzle and [`ets`][ets]
boosting the performance of a naïve algorithm enough that I didn't have to scrap
it. A few puzzles felt like they would have been slightly easier in a language
with mutable data structures, but only slightly.

New to this event, and an aspect I enjoyed quite a bit, were puzzles that
encouraged reusing and enhancing code written for earlier puzzles. The
"Assembunny" virtual machine used for days [12](days/12), [23](days/23), and
[25](days/25) is explicitly this, while days [11](days/11), [13](days/13),
[17](days/17), [22](days/22), _and_ [24](days/24) all require a shortest-path
algorithm. I unintentionally made this harder for myself when I wrongly
concluded, deep in the struggle with Day 11, that a breadth-first search
wouldn't perform well enough, and instead implemented `A*` from scratch using
the [Wikipedia article] as a reference. It's unfortunate that Day 11 is the
first in this series, given it's also (in my view) the steepest difficulty spike
in the whole event.

Also new to this event, and an aspect I enjoyed a lot less, was a puzzle
([Day 22](days/22)) where a general solution based only on the problem statement
is actually impossible, and success requires noticing certain properties of the
input data that allow cutting corners. The "lesson" here isn't a bad one, but
coming out of left field after 46 puzzles that allowed and encouraged general
solutions, it felt more like a cheap gotcha than a clever twist; I was almost
_offended_ at the puzzle design when I eventually looked up a hint.

Overall, then, for me this event had both higher highs and lower lows than 2015.
At the time of writing I haven't started 2017, but I'm interested to see what
the difficulty curve will be like, and whether it will keep the aspects of code
reuse introduced in this one.

[digraph]: https://www.erlang.org/doc/man/digraph.html
[ets]: https://www.erlang.org/doc/man/ets.html
[subreddit]: https://www.reddit.com/r/adventofcode/
[Wikipedia article]: https://en.wikipedia.org/wiki/A*_search_algorithm
