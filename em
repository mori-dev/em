#!/bin/bash

# USAGE:
#   $ command | em

emacsclient=`which emacsclient 2>&1`
if [ ! $? -eq 0 ] || [ ! -x $emacsclient ]; then
  echo 'emacsclient cannot available.'
  exit 1
fi

if [ $# = 0 ]; then
  TMP_FILE=`mktemp /tmp/emacsclient.XXXXXX`
  cat > $TMP_FILE
  sexp=$(cat <<EOF
    (let ((b (create-file-buffer "*stdin*")))
      (switch-to-buffer b)
      (insert-file-contents "${TMP_FILE}")
      (delete-file "${TMP_FILE}"))
EOF
  )
  $emacsclient -a emacs -e "$sexp"
else
  $emacsclient -a emacs $@ &
fi

[[ -e `which wmctrl` ]]  && wmctrl -a emacs
