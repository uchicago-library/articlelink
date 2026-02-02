val openurl_to_links :
  string -> ((string * string) list, string) result
(** [openurl_to_links] takes in an openurl, makes an HTTP request to
    SFX, and returns an association list with provider names as keys
    and links to electronic resources.  *)

val openurl_to_xml : string -> (string, string) result
(** [openurl_to_xml] takes in an openurl, makes an HTTP request to
    SFX, and returns the raw XML response from SFX as a string.  For
    debugging only.  *)

val to_sfx_curl : string -> string
(** [to_sfx_curl] takes in an SFX openurl and returns the curl command
    that is analogous to the HTTP request that [articlelink] makes to
    the SFX API.  For debugging only. *)
