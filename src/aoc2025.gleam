import day04
import gleam/string
import simplifile as file

pub fn main() {
  let assert Ok(data) = file.read("data/day04.txt")
  let input =
    data
    |> string.trim
    |> string.split("\n")

  // day01.part1(input)
  // day01.part2(input)
  // let assert Ok(data) = file.read("data/day02.txt")
  // let input = string.trim(data)
  day04.part1(input)
  day04.part2(input)
}
