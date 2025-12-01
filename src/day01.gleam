import gleam/int
import gleam/list
import gleam/string

pub fn part1(input: List(String)) {
  let turns =
    input
    |> list.map_fold(50, fn(acc, l) {
      let assert Ok(#(d, n)) = string.pop_grapheme(l)
      let assert Ok(count) = int.parse(n)
      let assert Ok(new_pos) = case d {
        "L" -> int.modulo(acc + -1 * count, 100)
        _ -> int.modulo(acc + count, 100)
      }
      #(new_pos, new_pos)
    })

  echo list.count(turns.1, fn(x) { x == 0 })
}

pub fn part2(input: List(String)) {
  let turns =
    input
    |> list.map(fn(l) {
      let assert Ok(#(d, n)) = string.pop_grapheme(l)
      let assert Ok(count) = int.parse(n)
      case d {
        "L" -> -1 * count
        _ -> count
      }
    })
    |> list.map_fold(50, fn(pos, x) {
      let start = case x {
        i if i < 0 -> { 100 - pos } % 100
        _ -> pos
      }
      let assert Ok(new_pos) = int.modulo(pos + x, 100)
      let count = { start + int.absolute_value(x) } / 100
      #(new_pos, count)
    })

  echo list.fold(turns.1, 0, int.add)
}
