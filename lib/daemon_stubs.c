#include <string.h>

#include <caml/memory.h>
#include <caml/mlvalues.h>
#include <caml/signals.h>
#include <caml/fail.h>
#include <caml/unixsupport.h>

/* to suppress logging information about this file */
#define SD_JOURNAL_SUPPRESS_LOCATION

#include <systemd/sd-daemon.h>

CAMLprim value caml_daemon_listen_fds(value unset_environment) {
  /* booleans are integers 0 1 -> no need to map */
  int ret = sd_listen_fds(Bool_val(unset_environment));
  if (ret < 0)
    unix_error(ret, "daemon_listen_fds", Nothing);
  else
    return Val_int(ret);
}

CAMLprim value caml_daemon_booted() {
  int ret = sd_booted();
  if (ret < 0)
    unix_error(ret, "daemon_booted", Nothing);
  return (ret == 0)?Val_false:Val_true;
}
