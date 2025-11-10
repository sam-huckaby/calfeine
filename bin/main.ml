(* Main entry point for Calfeine web server *)

let () =
  let port = ref 8080 in
  let whitelist_file = ref "files.site" in
  
  let usage_msg = "calfeine [options]" in
  let specs = [
    ("-p", Arg.Set_int port, "Port to listen on (default: 8080)");
    ("-f", Arg.Set_string whitelist_file, "Whitelist file (default: files.site)");
  ] in
  
  Arg.parse specs (fun _ -> ()) usage_msg;
  
  Printf.printf "Starting Calfeine...\n%!";
  Eio_main.run @@ fun env ->
    Printf.printf "Eio environment initialized\n%!";
    Eio.Switch.run @@ fun sw ->
      Printf.printf "Switch created, starting server...\n%!";
      Calfeine.Server.run 
        ~sw
        ~net:env#net
        ~fs:env#cwd
        ~port:!port
        ~whitelist_file:!whitelist_file
