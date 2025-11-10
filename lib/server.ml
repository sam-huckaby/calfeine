(* HTTP server implementation using Eio and Cohttp *)

let handle_request ~fs ~whitelist _conn request _body =
  let uri = Http.Request.resource request in
  let path = Uri.path (Uri.of_string uri) in
  
  (* Default to index.html for root path *)
  let path = if path = "/" then "/index.html" else path in
  
  if Whitelist.is_allowed whitelist path then begin
    (* Remove leading slash for filesystem access *)
    let file_path = if String.starts_with ~prefix:"/" path then
      String.sub path 1 (String.length path - 1)
    else path in
    
    try
      let content = Eio.Path.(load (fs / file_path)) in
      let mime_type = Whitelist.get_mime_type file_path in
      let headers = Http.Header.of_list [
        ("Content-Type", mime_type);
      ] in
      Cohttp_eio.Server.respond_string ~status:`OK ~headers ~body:content ()
    with
    | Eio.Io _ ->
        Printf.eprintf "File not found: %s\n%!" file_path;
        Cohttp_eio.Server.respond_string ~status:`Not_found ~body:"404 Not Found" ()
  end else begin
    Printf.printf "Access denied: %s\n%!" path;
    Cohttp_eio.Server.respond_string ~status:`Not_found ~body:"404 Not Found" ()
  end

let run ~sw ~net ~fs ~port ~whitelist_file =
  let whitelist = Whitelist.load_whitelist ~fs whitelist_file in
  Printf.printf "Loaded %d files from whitelist\n%!" 
    (Whitelist.StringSet.cardinal whitelist);
  
  let socket = 
    Eio.Net.listen net ~sw ~reuse_addr:true ~backlog:128
      (`Tcp (Eio.Net.Ipaddr.V4.loopback, port))
  in
  
  Printf.printf "Calfeine server listening on http://127.0.0.1:%d\n%!" port;
  
  let server = Cohttp_eio.Server.make ~callback:(handle_request ~fs ~whitelist) () in
  Cohttp_eio.Server.run socket server ~on_error:(fun exn ->
    Printf.eprintf "Server error: %s\n%!" (Printexc.to_string exn)
  )
