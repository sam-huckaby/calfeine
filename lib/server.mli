(* Server interface *)

val run : 
  sw:Eio.Switch.t ->
  net:_ Eio.Net.t ->
  fs:_ Eio.Path.t ->
  port:int ->
  whitelist_file:string ->
  unit
(** Start the HTTP server *)
