let percent_encode openurl =
  let query = [ ("openurl", [ openurl ]) ] in
  Uri.encoded_of_query query
