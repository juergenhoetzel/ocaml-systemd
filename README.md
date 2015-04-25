# Basic Usage

```OCaml
open Journald

let () = journal_send_message Priority.INFO "Hello";

	 (* compile and link its compilation units with option -g to get CODE_FILE and CODE_LINE entries*)
	 journal_send_message_loc Priority.INFO "Hello with location";
	 (* compile and link its compilation units with option -g *)
	 journal_send ["CUSTOM_FIELD", "CUSTOM_VALUE"];
	 journal_send_loc ["CUSTOM_FIELD", "CUSTOM_VALUE with location"];
```

# Performance

To get callstack info (required for the implicit
`CODE_FILE` and `CODE_LINE` entries) you need to build your
compilation units with
debugging information.

Getting the callstack at runtime also results in an performance overhead, so there a 2 groups of journal functions:

With location fields:

```OCaml
val journal_send_message_loc : Priority.t -> string -> unit
val journal_send_loc : (string * string) list -> unit
```

Without location fields:

```OCaml
val journal_send : (string * string) list -> unit
val journal_send_message : Priority.t -> string -> unit
```
