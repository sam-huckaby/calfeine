(* Module for managing the files.site allowlist *)

module StringSet = Set.Make(String)

type t = StringSet.t

(* Maybe this should be in a file too? Or maybe we just don't care and whatever is in the files.site list is good to go? *)
let allowed_extensions = [
  ".html"; ".htm";           (* HTML files *)
  ".css";                    (* Stylesheets *)
  ".js";                     (* JavaScript *)
  ".ico"; ".png"; ".jpg"; ".jpeg"; ".gif";  (* Images *)
  ".woff"; ".woff2"; ".ttf"; ".otf"; ".eot" (* Fonts *)
]

let has_allowed_extension filename =
  List.exists (fun ext -> Filename.check_suffix filename ext) allowed_extensions

let load_allowlist ~fs filename =
  try
    let content = Eio.Path.(load (fs / filename)) in
    let lines = String.split_on_char '\n' content in
    let files = 
      lines
      |> List.map String.trim
      |> List.filter (fun line -> line <> "" && not (String.starts_with ~prefix:"#" line))
      |> List.filter has_allowed_extension
    in
    StringSet.of_list files
  with
  | Eio.Io _ -> 
      Printf.eprintf "Warning: Could not load %s, using empty allowlist\n%!" filename;
      StringSet.empty

let is_allowed allowlist path =
  (* Remove leading slash if present *)
  let path = if String.starts_with ~prefix:"/" path then
    String.sub path 1 (String.length path - 1)
  else path in
  StringSet.mem path allowlist

let get_mime_type filename =
  if Filename.check_suffix filename ".html" || Filename.check_suffix filename ".htm" then "text/html"
  else if Filename.check_suffix filename ".css" then "text/css"
  else if Filename.check_suffix filename ".js" then "application/javascript"
  else if Filename.check_suffix filename ".png" then "image/png"
  else if Filename.check_suffix filename ".jpg" || Filename.check_suffix filename ".jpeg" then "image/jpeg"
  else if Filename.check_suffix filename ".gif" then "image/gif"
  else if Filename.check_suffix filename ".ico" then "image/x-icon"
  else if Filename.check_suffix filename ".woff" then "font/woff"
  else if Filename.check_suffix filename ".woff2" then "font/woff2"
  else if Filename.check_suffix filename ".ttf" then "font/ttf"
  else if Filename.check_suffix filename ".otf" then "font/otf"
  else if Filename.check_suffix filename ".eot" then "application/vnd.ms-fontobject"
  else "application/octet-stream"
