let prios_file = "lib/prios/prios"

let list_to_tup lst =
  let open Etude.Option in
  let+ provider = List.nth_opt lst 0
  and+ rank = List.nth_opt lst 1 >>= int_of_string_opt in
  (provider, rank)

let csv_list_to_tups lst =
  Etude.Option.traverse list_to_tup (Prelude.drop 1 lst)

let csv_load_opt filepath =
  match Csv.load filepath with
  | exception _ -> None
  | legit -> Some legit

let sort_tups tups =
  let comparison (_, i) (_, j) = Int.compare i j in
  List.stable_sort comparison tups

let cleanup str =
  let each_char = function
    | '_' -> ' '
    | c -> Char.lowercase_ascii c
  in
  String.map each_char str

let filepath_to_ranking filepath =
  let open Etude.Option in
  let* csv = csv_load_opt filepath in
  let* tups = csv_list_to_tups csv in
  let cleanup_project (x, _) = cleanup x in
  pure (tups |> sort_tups |> List.map cleanup_project)

let compy ranking (x, _) (y, _) =
  Etude.Sort.list_to_ranking ranking (cleanup x) (cleanup y)

let rec get_idx n key = function
  | [] -> n
  | x :: xs -> if key = x then n else get_idx (n + 1) key xs

let sort_hits hits =
  let ranking = filepath_to_ranking prios_file in
  match ranking with
  | None -> hits
  | Some r ->
    let comp x y =
      Printf.printf "%s: %i\n%s: %i\n\n" (fst x)
        (get_idx 0 (cleanup (fst x)) r)
        (fst y)
        (get_idx 0 (cleanup (fst y)) r) ;
      compy r x y
    in
    List.stable_sort comp hits
