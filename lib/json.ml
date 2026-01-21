let to_string json =
  let () = Data_encoding.Json.pp
             Format.str_formatter
             json
  in Format.flush_str_formatter ()

let print ?truncate json =
  let print_entire json =
    Format.printf
      "%a"
      (Json_repr.pp (module Json_repr.Ezjsonm))
      json
  in
  match truncate with
  | Some n -> Prelude.print
              @@ Prelude.String.take n
              @@ to_string json
  | None -> print_entire json

let hits_to_json hits =
  let each_hit (journal, link) =
    `O [ "provider", `String journal ;
         "link", `String link ]
  in `O [ "hits", `A (List.map each_hit hits) ]

let error_json s =
  `O ["error", `String s]
  |> to_string
