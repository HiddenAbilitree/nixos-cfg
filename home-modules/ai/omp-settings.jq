def leaves:
  to_entries[]
  | [.key] as $key
  | .value
  | if type == "object" and length > 0 then $key + leaves else $key end;

def at($path): try getpath($path) catch null;

def nest($path; $value): reduce ($path | reverse[]) as $key ($value; {($key): .});

($base[0] // {}) as $base
| $new[0] as $new
| [$base | leaves] as $previous
| [$new | leaves] as $declared
| reduce ($previous - $declared)[] as $path (
    .[0] // {};
    ($base | getpath($path)) as $old
    | if $old != null and at($path) == $old then delpaths([$path]) end
  )
| reduce ($declared[] | select(. as $path | ($base | at($path)) != ($new | getpath($path)))) as $path (
    .;
    . * nest($path; $new | getpath($path))
  )
