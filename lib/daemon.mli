(** OCaml interface to the libsystemd-daemon library. *)

module State : sig
    type t =
      | Ready 			(* Service startup is finished *)
      | Reloading		(* Service is reloading its configuration. Has to send Ready when finished reloading *)
      | Stopping		(* Service is beginning to shutdown *)
      | Status of string	(* Passes a single UTF-8 status string *)
      | Error of Unix.error     (* Service failed with Unix Erro *)
      | Bus_error of string	(* Service failed with D-Bus error-style error code *)
      | Main_pid of int 	(* The main process ID *)
      | Watchdog		(* Update the watchdog timestamp *)
  end				(* FDSTORE not implemented yet *)

(** [notify unset_environment state] Send a message to the init
system about a status change. If the status was sent return true. May
raise [Unix_error] *)
val notify : bool -> State.t -> bool

(** [listen_fds unset_environment] Return the number of
descriptors passed to this process by the init system as part of the
socket-based activation logic or raises [Unix_error] *)
val listen_fds : bool -> int

(** [booted] Return true if this system is running under
systemd. or raises [Unix_error] *)
val booted : unit -> bool
