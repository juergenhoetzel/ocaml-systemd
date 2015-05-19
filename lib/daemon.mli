(** OCaml interface to the libsystemd-daemon library. *)


(** [daemon_listen_fds unset_environment] Return the number of
descriptors passed to this process by the init system as part of the
socket-based activation logic or raises [Unix_error] *)
val daemon_listen_fds : bool -> int

(** [daemon_booted] Return true if this system is running under
systemd. or raises [Unix_error] *)
val daemon_booted : unit -> bool
