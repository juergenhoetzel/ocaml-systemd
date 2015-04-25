module Priority : sig
    type t = EMERG | ALERT | CRIT | ERR | WARNING | NOTICE | INFO | DEBUG
    val to_int : t -> int
end

val journal_send : (string * string) list -> unit
(* compile and link its compilation units with option -g *)
val journal_send_loc : (string * string) list -> unit

val journal_send_message : Priority.t -> string -> unit
(* compile and link its compilation units with option -g *)
val journal_send_message_loc : Priority.t -> string -> unit


