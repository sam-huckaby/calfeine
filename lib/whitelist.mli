(* Interface for whitelist management *)

module StringSet : Set.S with type elt = string

type t = StringSet.t

val allowed_extensions : string list
(** List of allowed file extensions *)

val has_allowed_extension : string -> bool
(** Check if a filename has an allowed extension *)

val load_whitelist : fs:_ Eio.Path.t -> string -> t
(** Load whitelist from a file *)

val is_allowed : t -> string -> bool
(** Check if a path is in the whitelist *)

val get_mime_type : string -> string
(** Get MIME type based on file extension *)
