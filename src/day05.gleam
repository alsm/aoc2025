import gleam/int
import gleam/list
import gleam/string

pub type IntRange {
  IntRange(min: Int, max: Int)
}

fn contains(r: IntRange, v: Int) -> Bool {
  v >= r.min && v <= r.max
}

fn range_size(r: IntRange) -> Int {
  r.max - r.min + 1
}

fn overlap(a: IntRange, b: IntRange) -> Bool {
  a.min <= b.max + 1 && b.min <= a.max + 1
}

fn merge(a: IntRange, b: IntRange) -> IntRange {
  IntRange(int.min(a.min, b.min), int.max(a.max, b.max))
}

pub fn part2(fresh: List(String)) -> Int {
  echo fresh
    |> list.filter_map(fn(l) {
      case string.split_once(l, "-") {
        Ok(#(min, max)) ->
          case int.parse(min), int.parse(max) {
            Ok(minv), Ok(maxv) -> Ok(IntRange(minv, maxv))
            _, _ -> Error(Nil)
          }
        _ -> Error(Nil)
      }
    })
    |> list.sort(fn(a, b) { int.compare(a.min, b.min) })
    |> merge_sorted([])
    |> list.map(range_size)
    |> list.fold(0, int.add)
}

fn merge_sorted(ranges: List(IntRange), acc: List(IntRange)) -> List(IntRange) {
  case ranges, acc {
    [], _ -> list.reverse(acc)
    [first, ..rest], [] -> merge_sorted(rest, [first])
    [current, ..rest], [last, ..previous] ->
      case overlap(last, current) {
        True -> merge_sorted(rest, [merge(last, current), ..previous])
        False -> merge_sorted(rest, [current, last, ..previous])
      }
  }
}

pub fn part1(fresh: List(String), ingred: List(String)) {
  let ranges =
    fresh
    |> list.filter_map(fn(l) {
      case string.split_once(l, "-") {
        Ok(#(min, max)) ->
          case int.parse(min), int.parse(max) {
            Ok(minv), Ok(maxv) -> Ok(IntRange(minv, maxv))
            _, _ -> Error(Nil)
          }
        _ -> Error(Nil)
      }
    })

  echo ingred
    |> list.filter_map(int.parse)
    |> list.filter(fn(v) -> Bool {
      list.any(ranges, fn(r) -> Bool { contains(r, v) })
    })
    |> list.length
}
