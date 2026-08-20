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

(* let cleanup str = *)
(*   let each_char = function *)
(*     | '_' -> ' ' *)
(*     | c -> Char.lowercase_ascii c *)
(*   in *)
(*   String.map each_char str *)

let filepath_to_ranking filepath =
  let open Etude.Option in
  let* csv = csv_load_opt filepath in
  let* tups = csv_list_to_tups csv in
  (* uncomment this once debugging is done *)
  (* let cleanup_project (x, _) = cleanup x in *)
  let cleanup_project (x, _) = x in
  pure (tups |> sort_tups |> List.map cleanup_project)

let sort_hits_ranking ranking hits =
  let open Etude.Sort in
  let provider_comp x y = list_to_ranking ranking x y in
  let comp (provider1, _) (provider2, _) =
    provider_comp provider1 provider2
  in
  List.stable_sort comp hits

let sort_hits hits =
  let ranking_opt = filepath_to_ranking prios_file in
  match ranking_opt with
  | None -> hits
  | Some ranking -> sort_hits_ranking ranking hits
