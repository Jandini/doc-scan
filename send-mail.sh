#!/bin/bash
sendemail -f matt.janda.kingston@gmail.com \
   -t matt.janda.kingston@gmail.com \
   -u "This is the subject" \
   -m "This is a short body" \
   -s smtp.gmail.com:587 \
   -o tls=yes -xu USERNAME -xp PASSWORD