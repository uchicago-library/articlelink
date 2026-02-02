val openurl_to_links :
  string -> ((string * string) list, string) result
(** [openurl_to_links] takes in an openurl, makes an HTTP request to
    SFX, and returns an association list with provider names as keys
    and links to electronic resources.  *)

val openurl_to_xml : string -> (string, string) result
(** [openurl_to_xml] takes in an openurl, makes an HTTP request to
    SFX, and returns the raw XML response from SFX as a string.  For
    debugging only.  *)
