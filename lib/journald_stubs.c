#include <string.h>
#include <syslog.h>

#include <caml/memory.h>
#include <caml/mlvalues.h>
#include <caml/signals.h>
#include <caml/fail.h>

/* to suppress logging information about this file */
#define SD_JOURNAL_SUPPRESS_LOCATION

#include <systemd/sd-journal.h>

static int priorities[] = { LOG_EMERG, LOG_ALERT, LOG_CRIT, LOG_ERR, LOG_WARNING,
			    LOG_NOTICE, LOG_INFO, LOG_DEBUG};
/* helper function */
static int caml_list_length(value v_slist) {
  int n = 0;
  while ( v_slist != Val_emptylist ) {
    v_slist = Field(v_slist, 1);
    n++;
  }
  return n;
}

CAMLprim value caml_journal_level_to_int(value v_level) {
  return Val_int(priorities[Int_val(v_level)]);
}

/* send structured log entries to the system journal */

CAMLprim value caml_journal_send(value v_slist) {
  int count;
  int i = 0;
  struct iovec *iovecs;
  CAMLparam1(v_slist);
  CAMLlocal1( head );
  count = caml_list_length(v_slist);
  iovecs = caml_stat_alloc(sizeof(struct iovec) * count);
  while ( v_slist != Val_emptylist ) {
      head = Field(v_slist, 0);
      iovecs[i].iov_len = caml_string_length(head);
      iovecs[i].iov_base = String_val(head);
      v_slist = Field(v_slist, 1);
      i++;
  }
  sd_journal_sendv(iovecs, count);
  caml_stat_free(iovecs);
  CAMLreturn(Val_unit);
}
