(** Submit log entries to the system journal.  *)

module Priority : sig
    type t =
      |	EMERG 			(** System is unusable *)
      | ALERT			(** Action must be taken immediately *)
      | CRIT			(** Critical condition *)
      | ERR			(** Error conditions *)
      | WARNING			(** Warning conditions *)
      | NOTICE			(** Normal, but significant, condition *)
      | INFO			(** Informational message *)
      | DEBUG			(** Debug-level message *)
    val to_int : t -> int
end

(** [journal_send] submits a list of KV pairs to the journal. The Key
name must be in uppercase and consist only of characters, numbers and
underscores, and may not begin with an underscore. *)
val journal_send : (string * string) list -> unit


val journal_send_loc : (string * string) list -> unit
(** [journal_send_loc] acts like [journal_send], but also adds the CODE_LINE and CODE_FILE location keys and values to the journal.

Compilation units must be compiled and linked with option -g *)

val journal_send_message : Priority.t -> string -> unit
(** [journal_send_message p s] is used to submit simple, plain text
log entries to the system journal. The first argument is the
[Priority] [p]. This is followed by the message [s] *)

val journal_send_message_loc : Priority.t -> string -> unit
(** [journal_send_message_loc] acts like [journal_send_message], but also adds the CODE_LINE and CODE_FILE location keys and values to the journal.

Compilation units must be compiled and linked with option -g *)
