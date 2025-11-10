(* Module for managing the files.site whitelist *)

module StringSet = Set.Make(String)

type t = StringSet.t

(* Maybe this should be in a file too? Or maybe we just don't care and whatever is in the files.site list is good to go? *)
let allowed_extensions = [".html"; ".ico"; ".png"]

let has_allowed_extension filename =
  List.exists (fun ext -> Filename.check_suffix filename ext) allowed_extensions

let load_whitelist ~fs filename =
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
      Printf.eprintf "Warning: Could not load %s, using empty whitelist\n%!" filename;
      StringSet.empty

let is_allowed whitelist path =
  (* Remove leading slash if present *)
  let path = if String.starts_with ~prefix:"/" path then
    String.sub path 1 (String.length path - 1)
  else path in
  StringSet.mem path whitelist

let get_mime_type filename =
  if Filename.check_suffix filename ".html" then "text/html"
  else if Filename.check_suffix filename ".png" then "image/png"
  else if Filename.check_suffix filename ".ico" then "image/x-icon"
  else "application/octet-stream"
