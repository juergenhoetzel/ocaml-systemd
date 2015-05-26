# ocaml-systemd [![Build Status](https://api.travis-ci.org/juergenhoetzel/ocaml-systemd.svg)](https://travis-ci.org/juergenhoetzel/ocaml-systemd/)

OCaml library allowing interaction with systemd and journald

# Journald Usage

```OCaml
open Journald

let () = journal_send_message Priority.INFO "Hello";

	 (* compile and link its compilation units with option -g to get CODE_FILE and CODE_LINE entries*)
	 journal_send_message_loc Priority.INFO "Hello with location";
	 (* compile and link its compilation units with option -g *)
	 journal_send ["CUSTOM_FIELD", "CUSTOM_VALUE"];
	 journal_send_loc ["CUSTOM_FIELD", "CUSTOM_VALUE with location"];
```

## Performance

To get callstack info (required for the implicit
`CODE_FILE` and `CODE_LINE` entries) you need to build your
compilation units with
debugging information.

Getting the callstack at runtime also results in an performance overhead, so there a 2 groups of journal functions:

### Journal functions with location info

```OCaml
val journal_send_message_loc : Priority.t -> string -> unit
val journal_send_loc : (string * string) list -> unit
```

### Journal functions without location info

```OCaml
val journal_send : (string * string) list -> unit
val journal_send_message : Priority.t -> string -> unit
```

# Socket activation

No need for forking the process, binding/listening the sockets.

Also support for systemd watchdog functionality.

## Complete Example: Lwt echo server using socket activation

```Ocaml
open Daemon
open Daemon.State
open Lwt
open Lwt_unix
open Journald

let echo_server conn_fd =
  let in_channel = Lwt_io.of_fd ~mode:Lwt_io.input conn_fd in
  let out_channel = Lwt_io.of_fd ~mode:Lwt_io.output conn_fd in
  finalize (fun () -> Lwt_stream.iter_s (Lwt_io.write_line out_channel) (Lwt_io.read_lines in_channel))
	   (fun () -> close conn_fd)

let rec accept fd =
  Lwt_unix.accept (Lwt_unix.of_unix_file_descr fd)
  >>= (fun (conn_fd, _) ->
       async (fun _ -> echo_server conn_fd);
       accept fd)

let _ =
  (* Notify systemd software watchdog every second *)
  Lwt_engine.on_timer 1.0 true (fun _ -> notify Watchdog|>ignore);
  notify Ready |> ignore;
  match listen_fds () with
  | [] -> journal_send_message Priority.CRIT "No file descriptors passed by the system manager"
  | fd::_ -> journal_send_message Priority.INFO "socket activation succeded";
	     accept fd |> Lwt_main.run
```
