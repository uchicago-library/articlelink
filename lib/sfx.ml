let xml_to_targets xml_string =
  xml_string
  |> Ezxmlm.from_string
  |> snd
  |> Ezxmlm.member "ctx_obj_set"
  |> Ezxmlm.member "ctx_obj"
  |> Ezxmlm.member "ctx_obj_targets"
  |> Ezxmlm.members "target"

let retrieve_unique field_name target =
  target
  |> Ezxmlm.members field_name
  |> List.map Ezxmlm.data_to_string
  |> String.concat ""

let get_info target =
  retrieve_unique "service_type" target ,
  retrieve_unique "target_public_name" target ,
  retrieve_unique "target_url" target

let get_link xml_string =
  let has_full_link =
    function | "getFullTxt",_,_ -> true
             | _ -> false
  in
  let shrink (_, provider, link) = (provider, link) in
  xml_string
  |> xml_to_targets
  |> List.map get_info
  |> List.filter has_full_link
  |> List.map shrink

let get_from_filepath filepath =
  let sfx_output = Prelude.readfile filepath
  in get_link sfx_output

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

let to_sfx_curl findit_openurl =
  "curl -sL \"" ^ findit_to_api findit_openurl ^ "\""

let openurl_to_xml findit_openurl =
  let url = findit_to_api findit_openurl in
  get_xml_string url

let openurl_to_links findit_openurl =
  let xml_string_result =
    openurl_to_xml findit_openurl
  in
  Result.map get_link xml_string_result
