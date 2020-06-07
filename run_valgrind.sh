#!/usr/bin/env bash

# will run executable that is provided as an argument.

G_SLICE=always-malloc G_DEBUG=resident-modules\
       valgrind --tool=memcheck \
         --leak-check=full \
         --leak-resolution=high \
         --num-callers=20 \
         --suppressions=/usr/share/glib-2.0/valgrind/glib.supp \
         --log-file=vgdump \
         "$@"
