import day01
import gleam/string
import simplifile as file

pub fn main() {
  let assert Ok(data) = file.read("data/day01.txt")
  let input =
    data
    |> string.trim
    |> string.split("\n")

  day01.part1(input)
  day01.part2(input)
}
