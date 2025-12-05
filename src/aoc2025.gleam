import day05
import gleam/string
import simplifile as file

pub fn main() {
  let assert Ok(data) = file.read("data/day05.txt")
  let assert Ok(#(fresh, ingred)) = string.split_once(data, "\n\n")

  // day01.part1(input)
  // day01.part2(input)
  // let assert Ok(data) = file.read("data/day02.txt")
  // let input = string.trim(data)
  day05.part1(string.split(fresh, "\n"), string.split(ingred, "\n"))
  day05.part2(string.split(fresh, "\n"))
}
