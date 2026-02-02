val hits_to_string : (string * string) list -> string
(** [hits_to_string] takes in an association list in which the keys
    are provider name strings and the values are links to electronic
    resources, and converts it to a JSON string of the kind
    [articlelink] outputs.  *)

val error_json : string -> string
(** [error_json] takes in an error message and outputs an [Data_encoding.json]
    JSON object containing that error message.  *)

val print : ?truncate:int -> Data_encoding.json -> unit
(** [print] pretty prints a value of type [Data_encoding.json].  For
     debugging in the REPL. *)
