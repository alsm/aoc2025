import gleam/dict
import gleam/list
import gleam/string

type Grid =
  dict.Dict(#(Int, Int), Bool)

pub fn part1(input: List(String)) {
  let map = parse_grid(input)
  echo map
    |> dict.keys
    |> list.filter(accessible(map, _))
    |> list.length
}

pub fn part2(input: List(String)) {
  echo input
    |> parse_grid
    |> remove_accessible_loop(0)
}

fn parse_grid(input: List(String)) -> Grid {
  input
  |> list.index_map(fn(line, row_i) { parse_line(line, row_i) })
  |> list.flatten
  |> dict.from_list
}

fn remove_accessible_loop(map: Grid, total_removed: Int) -> Int {
  let accessible_points =
    map
    |> dict.keys
    |> list.filter(accessible(map, _))

  case accessible_points {
    [] -> total_removed
    points -> {
      let new_map = list.fold(points, map, dict.delete)
      remove_accessible_loop(new_map, total_removed + list.length(points))
    }
  }
}

fn parse_line(row: String, row_i: Int) -> List(#(#(Int, Int), Bool)) {
  row
  |> string.to_graphemes
  |> list.index_map(fn(char, col_i) {
    case char {
      "@" -> Ok(#(#(col_i, row_i), True))
      _ -> Error(Nil)
    }
  })
  |> list.filter_map(fn(x) { x })
}

fn accessible(map: Grid, point: #(Int, Int)) -> Bool {
  let neighbors = [
    #(-1, -1),
    #(0, -1),
    #(1, -1),
    #(-1, 0),
    #(1, 0),
    #(-1, 1),
    #(0, 1),
    #(1, 1),
  ]

  neighbors
  |> list.count(fn(offset) {
    dict.has_key(map, #(point.0 + offset.0, point.1 + offset.1))
  })
  |> fn(count) { count < 4 }
}
