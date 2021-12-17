# Advent of Code 2020

PowerShell 7 solutions to the Advent of Code problems. Check out <https://adventofcode.com/2020>

- No third-party libraries / modules are used
- Both parts of each solution are self-contained, which may mean certain code repetition across parts/solutions
- Put `input.txt` as downloaded from the Advent of Code website into the folder corresponding to the day
- `cd` to the day's folder and run `.\part1.ps1` or `.\part2.ps1`
- Code formatted with [PowerShell Visual Studio Code Extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode.PowerShell)
- `LF` is used for line ending and UTF-8 without BOM for encoding
- Some solutions run longer than 10 seconds (depending on hardware): Day 11 Parts 1 & 2, Day 15 Part 2, Day 17 Part 2, Day 22 Part 2, Day 23 Part 2, Day 24 Part 2
- In Day 23 I lost part 1 solution accidentally and instead of re-creating it I re-purposed part 2 solution to calculate part 1, from scratch the initial attempt had less code
- `test.ps1` in the root folder can be used to run and time all the puzzles one after another, it assumes that `input.txt` is already in place
