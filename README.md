Basic Usage
--------------------

```OCaml
open Journald

let () = journal_send_message Priority.INFO "Hello";

	 (* compile and link its compilation units with option -g to get CODE_FILE and CODE_LINE entries*)
	 journal_send_message_loc Priority.INFO "Hello with location";
	 (* compile and link its compilation units with option -g *)
	 journal_send ["CUSTOM_FIELD", "CUSTOM_VALUE"];
	 journal_send_loc ["CUSTOM_FIELD", "CUSTOM_VALUE with location"];
```