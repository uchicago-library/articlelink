let list_to_result = function
  | [] -> Error "bad SFX xml"
  | x :: _ -> Ok x

let get_link xml_string =
  let get_info node =
    Ezxmlm.members "service_type" node
    |> List.map Ezxmlm.data_to_string, Ezxmlm.members "target_url" node
  in Ezxmlm.from_string xml_string
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
     |> list_to_result

let get_from_filepath filepath =
  let sfx_output = Prelude.readfile filepath
  in get_link sfx_output

let to_sfx_curl uri_string = "curl -sL \"" ^ uri_string ^ "\""

let get_xml_string uri_string =
  let get_body r = r.Httpr_cohttp.Response.body
  in uri_string
     |> Uri.of_string
     |> Httpr_cohttp.get
     |> Result.map get_body

let get_xml uri_string =
  Result.map Ezxmlm.from_string (get_xml_string uri_string)

let sfx_host = "sfx.lib.uchicago.edu"
let sfx_path = "sfx_local"

let findit_to_api
      ?(host=sfx_host)
      ?(path=sfx_path)
      uri_string =
  let api_qs_param = "sfx.response_type",
                     ["multi_obj_detailed_xml"] in
  let (!) = Prelude.flip in
  uri_string
  |> Uri.of_string
  |> !Uri.add_query_param api_qs_param
  |> !Uri.with_host (Some host)
  |> !Uri.with_path path
  |> Uri.to_string

let openurl_to_article findit_openurl =
  let url = findit_to_api findit_openurl in
  let xml_string_result = get_xml_string url in
  Result.bind xml_string_result get_link

let print_result = function
  | Ok s -> print_endline s
  | Error _ -> ()
