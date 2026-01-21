let to_string_lf json =
  let () = Data_encoding.Json.pp
             Format.str_formatter
             json
  in Format.flush_str_formatter ()

(* snarfed from attc *)
(* TODO: promote *)
let add_crs str =
  let b = Buffer.create 0 in
  let mk_new_string () =
    let each_char c =
      match c with
      | '\n' ->
         Buffer.add_char b '\r' ;
         Buffer.add_char b '\n'
      | _ -> Buffer.add_char b c
    in
    String.iter each_char str
  in
  mk_new_string () ;
  Buffer.contents b

let to_string json =
  add_crs (to_string_lf json)

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

let hits_to_string hits =
  hits_to_json hits |> to_string

let error_json s =
  `O ["error", `String s] |> to_string
