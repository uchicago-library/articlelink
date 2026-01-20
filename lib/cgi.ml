let list_to_option = function | [] -> None
                              | x :: _ -> Some x

let lookup key qs =
  Option.bind (List.assoc_opt key qs) list_to_option
