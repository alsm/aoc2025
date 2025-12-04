import gleam/int
import gleam/list
import gleam/order
import gleam/result
import gleam/string

pub fn part1(input: List(String)) {
  echo input
    |> list.map(string.to_graphemes)
    |> list.map(fn(x) {
      x
      |> list.combination_pairs
      |> list.map(fn(p) { p.0 <> p.1 })
      |> list.try_map(int.parse)
      |> result.unwrap([0])
      |> list.max(int.compare)
      |> result.unwrap(0)
    })
    |> list.fold(0, int.add)
}

pub fn part2(input: List(String)) {
  echo input
    |> list.map(string.to_graphemes)
    |> list.map(fn(d) {
      d
      |> max_sub(12)
      |> string.concat
      |> int.parse
      |> result.unwrap(0)
    })
    |> list.fold(0, int.add)
}

fn max_sub(digits: List(String), k: Int) -> List(String) {
  case k {
    0 -> []
    _ -> {
      let n = list.length(digits)
      case n < k {
        True -> digits
        False -> {
          let window = list.take(digits, n - k + 1)
          case max_in_window(window, 0, "0", 0) {
            #(max_digit, max_idx) -> {
              [max_digit, ..max_sub(list.drop(digits, max_idx + 1), k - 1)]
            }
          }
        }
      }
    }
  }
}

fn max_in_window(
  digits: List(String),
  idx: Int,
  current_max: String,
  max_idx: Int,
) -> #(String, Int) {
  case digits {
    [] -> #(current_max, max_idx)
    [d, ..rest] -> {
      case string.compare(d, current_max) {
        order.Gt -> max_in_window(rest, idx + 1, d, idx)
        _ -> max_in_window(rest, idx + 1, current_max, max_idx)
      }
    }
  }
}
