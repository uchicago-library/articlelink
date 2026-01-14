let message = "Your wish is granted.  Long live Jambi."

let x () = Prelude.readfile "lib/synthese.xml"

let list_to_option = function
  | [] -> None
  | x :: _ -> Some x

let get_link filepath =
  let sfx_output = Prelude.readfile filepath in
  let get_info node =
    Ezxmlm.members "service_type" node
    |> List.map Ezxmlm.data_to_string, Ezxmlm.members "target_url" node
  in Ezxmlm.from_string sfx_output
     |> snd
     |> Ezxmlm.member "ctx_obj_set"
     |> Ezxmlm.member "ctx_obj"
     |> Ezxmlm.member "ctx_obj_targets"
     |> Ezxmlm.members "target"
     |> List.map get_info
     |> List.filter (function ["getFullTxt"], _ -> true | _ -> false)
     |> List.map snd
     |> List.map List.hd
     |> List.map Ezxmlm.data_to_string
     |> Prelude.List.nub
     |> list_to_option
