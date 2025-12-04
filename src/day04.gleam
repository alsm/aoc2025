import gleam/dict
import gleam/list
import gleam/string

type Grid =
  dict.Dict(#(Int, Int), Bool)

pub fn part1(input: List(String)) {
  let #(_, cells) =
    input
    |> list.fold(#(0, []), fn(acc, line) {
      #(acc.0 + 1, list.append(acc.1, parse_line(line, acc.0)))
    })

  let map: Grid = dict.from_list(cells)
  echo map
    |> dict.keys
    |> list.filter(fn(p: #(Int, Int)) -> Bool { accessible(map, p) })
    |> list.length
}

pub fn part2(input: List(String)) {
  let #(_, cells) =
    input
    |> list.fold(#(0, []), fn(acc, line) {
      #(acc.0 + 1, list.append(acc.1, parse_line(line, acc.0)))
    })

  let map: Grid = dict.from_list(cells)
  echo remove_accessible_loop(map, 0)
}

fn remove_accessible_loop(map: Grid, total_removed: Int) -> Int {
  let accessible_points =
    map
    |> dict.keys
    |> list.filter(fn(p: #(Int, Int)) -> Bool { accessible(map, p) })

  case list.length(accessible_points) {
    0 -> total_removed
    count -> {
      let new_map =
        accessible_points
        |> list.fold(map, fn(acc_map, point) { dict.delete(acc_map, point) })

      remove_accessible_loop(new_map, total_removed + count)
    }
  }
}

fn parse_line(row: String, row_i: Int) -> List(#(#(Int, Int), Bool)) {
  let #(_, cells) =
    row
    |> string.to_graphemes()
    |> list.fold(#(0, []), fn(acc, char) {
      case char {
        "@" -> #(acc.0 + 1, list.append(acc.1, [#(#(acc.0, row_i), True)]))
        _ -> #(acc.0 + 1, acc.1)
      }
    })
  cells
}

fn accessible(map: Grid, point: #(Int, Int)) -> Bool {
  let around = [
    #(-1, 1),
    #(0, 1),
    #(1, 1),
    #(1, 0),
    #(1, -1),
    #(0, -1),
    #(-1, -1),
    #(-1, 0),
  ]

  {
    around
    |> list.filter(fn(p: #(Int, Int)) -> Bool {
      case dict.get(map, #(p.0 + point.0, p.1 + point.1)) {
        Ok(_) -> True
        _ -> False
      }
    })
    |> list.length
  }
  < 4
}
