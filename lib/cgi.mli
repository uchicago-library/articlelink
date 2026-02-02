(** [result_to_response] takes in a query string, maps it to a
    [Cgi.input.t], computes the [Cgi.output.t] by talking to the SFX
    API, then converts the [Cgi.output.t] to the string of a JSON
    response.  *)
val result_to_response : (string, string) result -> string
