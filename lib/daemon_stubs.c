#include <string.h>

#include <caml/memory.h>
#include <caml/alloc.h>
#include <caml/mlvalues.h>
#include <caml/signals.h>
#include <caml/fail.h>
#include <caml/unixsupport.h>

/* to suppress logging information about this file */
#define SD_JOURNAL_SUPPRESS_LOCATION

#include <systemd/sd-daemon.h>

CAMLprim value caml_daemon_listen_fds(value unset_environment) {
  /* booleans are integers 0 1 -> no need to map */
  CAMLparam1(unset_environment);
  CAMLlocal2(res, v);
  int n = sd_listen_fds(Bool_val(unset_environment));
  if (n < 0)
    unix_error(res, "daemon_listen_fds", Nothing);
  else if (n == 0) {
    res = Val_int(0);		/* the empty list */
  }
  else {
    /* FIXME: more than one fds received */
    res = caml_alloc_small(2,0);
    Field(res, 0) = Val_int(SD_LISTEN_FDS_START);
    Field(res, 1) = Val_int(0);
  }
  CAMLreturn(res);
}

CAMLprim value caml_daemon_booted() {
  int ret = sd_booted();
  if (ret < 0)
    unix_error(ret, "daemon_booted", Nothing);
  return (ret == 0)?Val_false:Val_true;
}

/* internal */
CAMLprim value caml_daemon_code_of_unix_error(value unix_error) {
  return Val_int(code_of_unix_error(unix_error));
}

CAMLprim value caml_daemon_notify(value unset_environment, value state) {
  int ret;
  caml_enter_blocking_section();
  ret = sd_notify(Bool_val(unset_environment), String_val(state));
  caml_leave_blocking_section();
  if (ret < 0)
    unix_error(ret, "daemon_notify", Nothing);
  return (ret == 0)?Val_false:Val_true;
}
