let lookup key qs =
  match List.assoc_opt key qs with
  | Some (v :: _) -> Ok v
  | _ -> Error (key ^ " not found in query string")

module Input = struct
  type mode =
    | JSON of string
    | JSONP of string * string
    | XMLDebug of string
end

let parse_qs qs =
  let query = Uri.query_of_encoded qs in
  let lookups =
    lookup "openurl" query ,
    lookup "callback" query ,
    lookup "xml" query
  in
  match lookups with
  | Ok openurl, Ok callback, Error _ ->
     Ok (Input.JSONP (openurl, callback))
  | Ok openurl, Error _, Error _
    | Ok openurl, Error _, Ok "false" ->
     Ok (Input.JSON openurl)
  | Ok openurl, _, Ok "true" ->
     Ok (Input.XMLDebug openurl)
  | Ok _, _, Ok other ->
     let msg = "xml parameter was "
               ^ other
               ^ "; should be true or false"
     in
     Error msg
  | Error e, _, _ ->
     Error e

module Output = struct
  type mode =
    | JSON of (string * string) list
    | JSONP of (string * string) list * string
    | XMLDebug of string
end

let compute =
  let open Etude.Result.Make (String) in
  function
  | Input.JSON openurl ->
     let+ hits = Sfx.openurl_to_links openurl
     in Output.JSON hits
  | Input.JSONP (openurl, callback) ->
     let+ hits = Sfx.openurl_to_links openurl
     in Output.JSONP (hits, callback)
  | Input.XMLDebug openurl ->
     let+ xml_string = Sfx.openurl_to_xml openurl
     in Output.XMLDebug xml_string

let output_to_response =
  let open Etude.Result.Make (String) in
  function
  | Output.JSON hits ->
     Json.(hits_to_json hits |> to_string)
  | _ -> assert false

