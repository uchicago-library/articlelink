(** [hits_to_string] takes in an association list in which the keys
    are provider name strings and the values are links to electronic
    resources, and converts it to a JSON string of the kind
    [articlelink] outputs.  *)

val hits_to_string : (string * string) list -> string


(** [error_json] takes in an error message and outputs an [Ezjsonm.t]
    JSON object containing that error message.  *)

val error_json : string -> string
