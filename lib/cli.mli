(** [percent_encode] takes in an unescaped openurl, percent escapes
    it, and puts it into the 'openurl' parameter of a query string *)

val percent_encode : string -> string
