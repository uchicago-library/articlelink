let list_to_option = function | [] -> None
                              | x :: _ -> Some x

let lookup_opt key qs =
  Option.bind (List.assoc_opt key qs) list_to_option

let lookup key qs =
  match lookup_opt key qs with
  | Some v -> Ok v
  | None -> Error (key ^ " not found in query string")

