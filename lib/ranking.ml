let list_to_tup lst =
  let open Etude.Option in
  let+ provider = List.nth_opt lst 0
  and+ rank = List.nth_opt lst 1 >>= int_of_string_opt in
  (provider, rank)

let csv_list_to_tups lst =
  Etude.Option.traverse list_to_tup (Prelude.drop 1 lst)

let cleanup str =
  let each_char = function
    | '_' -> ' '
    | c -> Char.lowercase_ascii c
  in
  String.map each_char str

let sort_tups tups =
  let comparison (_, i) (_, j) = Int.compare i j in
  List.stable_sort comparison tups

let filepath_to_ranking filepath =
  let open Etude.Option in
  let csv = Csv.load filepath in
  let+ tups = csv_list_to_tups csv in
  let cleanup_project (x, _) = cleanup x in
  tups |> sort_tups |> List.map cleanup_project
