#!/bin/awk

BEGIN {
    counter = 0
    valid = 0
}

{
    counter = 0
    split($1, rules, "-")
    split($3, chars, "")
    sub(/:/, "", $2)

    for (c in chars) {
        if ($2 == chars[c]) {
            counter++
        }
    }

    if (counter >= rules[1] && counter <= rules[2]) {
        valid++
    }
}

END {
    print valid"/"NR
}
