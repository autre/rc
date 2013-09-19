#!/usr/local/bin/awk -f

BEGIN {
        FACTOR = 5
}

/^[0-9][0-9]:[0-9][0-9]:/ {
        printf "%s --> %s\n",
               sec2srttime(srttime2sec($1) + FACTOR),
               sec2srttime(srttime2sec($3) + FACTOR)
        next
}
{ print }

function srttime2sec(s,     a, hh, mm, ss) {
        sub(/,/, ".", s)
        split(s, a, ":")
        hh = a[1] + 0
        mm = a[2] + 0
        ss = a[3] + 0

        return 3600 * hh + 60 * mm + ss
}

function sec2srttime(sec,   intpart, realpart, hh, mm, ss) {
        intpart = int(sec)
        realpart = sec - intpart
        hh = int(intpart / 3600)
        intpart %= 3600
        mm = int(intpart / 60)
        intpart %= 60
        ss = intpart

        return sprintf("%02d:%02d:%02d,%03d", hh, mm, ss, 1000 * realpart)
}
