let cgi () =
  let open Etude.Option in
  let qs_opt = Sys.getenv_opt "QUERY_STRING" in
  let result_to_option = function
    | Some qs -> Ok qs
    | None -> Error "empty query string"
  in
  let qs_res = result_to_option qs_opt in
  print_string (Lib.Cgi.result_to_response qs_res)

let main () =
  match Prelude.argv with
  | [] -> cgi ()
  | openurl :: [] ->
     Lib.Cli.percent_encode openurl
     |> print_endline
  | _ -> cgi ()

let () = main ()
