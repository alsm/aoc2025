import gleam/int
import gleam/list
import gleam/string

pub fn part1(input: String) {
  echo input
    |> string.split(",")
    |> list.flat_map(fn(range) {
      let assert Ok(#(start, end)) = parse_range(range)
      list.range(start, end)
      |> list.filter(repeats_twice)
    })
    |> list.fold(0, int.add)
}

pub fn part2(input: String) {
  echo input
    |> string.split(",")
    |> list.flat_map(fn(range) {
      let assert Ok(#(start, end)) = parse_range(range)
      list.range(start, end)
      |> list.filter(repeats)
    })
    |> list.fold(0, int.add)
}

fn parse_range(range: String) -> Result(#(Int, Int), Nil) {
  case string.split(range, "-") {
    [start_str, end_str] -> {
      let assert Ok(start) = int.parse(start_str)
      let assert Ok(end) = int.parse(end_str)
      Ok(#(start, end))
    }
    _ -> Error(Nil)
  }
}

fn repeats_twice(num: Int) -> Bool {
  let digits = int.to_string(num) |> string.to_graphemes
  let len = list.length(digits)

  case len % 2 {
    0 -> {
      let pattern_len = len / 2
      let pattern = list.take(digits, pattern_len)
      let expected = list.repeat(pattern, 2) |> list.flatten
      digits == expected
    }
    _ -> False
  }
}

fn repeats(num: Int) -> Bool {
  let digits = int.to_string(num) |> string.to_graphemes
  let len = list.length(digits)

  list.range(1, len / 2)
  |> list.any(fn(pattern_len) {
    case len % pattern_len {
      0 -> {
        let num_repeats = len / pattern_len
        case num_repeats >= 2 {
          True -> {
            let pattern = list.take(digits, pattern_len)
            let expected = list.repeat(pattern, num_repeats) |> list.flatten
            digits == expected
          }
          False -> False
        }
      }
      _ -> False
    }
  })
}
