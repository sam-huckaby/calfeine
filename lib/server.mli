(* Server interface *)

val run : 
  sw:Eio.Switch.t ->
  net:_ Eio.Net.t ->
  fs:_ Eio.Path.t ->
  port:int ->
  allowlist_file:string ->
  unit
(** Start the HTTP server *)
