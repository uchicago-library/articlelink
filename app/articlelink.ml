let main () =
  match Prelude.argv with
  | [] -> print_endline "cgi stub"
  | openurl :: [] ->
     Lib.Cgi.percent_encode openurl
     |> print_endline
  | _ -> print_endline "cgi_stub"

let () = main ()
