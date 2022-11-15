open Printexc

module Priority = struct
  type t =
    | EMERG | ALERT | CRIT | ERR | WARNING | NOTICE | INFO | DEBUG
  external to_int : t -> int = "caml_journal_level_to_int"
end

external caml_journal_send : string list -> unit = "caml_journal_send"

let journal_send l = List.map (function (k,v) -> k ^ "=" ^ v) l |> caml_journal_send

let default_entries p s = ("PRIORITY", ((Priority.to_int p) |> string_of_int))::("MESSAGE", s)::[]

let journal_send_message p s = default_entries p s |> journal_send

(* assuming get_location is called from function in backtrace 3 slots above   *)
let get_location () = match (get_callstack 3 |> backtrace_slots) with
  | Some s -> Array.get s 2 |> Slot.location
  | None -> None

let journal_send_loc l = match get_location () with
  | Some {filename; line_number; _} -> journal_send (("CODE_FILE", filename)::("CODE_LINE", string_of_int line_number)::l)
  | None -> journal_send l

let journal_send_message_loc p s = match get_location () with
  | Some {filename; line_number; _} -> journal_send (("CODE_FILE", filename)::("CODE_LINE", string_of_int line_number)::(default_entries p s))
  | None -> journal_send_message p s
