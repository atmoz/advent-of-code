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

    for (r in rules) {
        if (chars[rules[r]] == $2) {
            counter++
        }
    }

    if (counter == 1) {
        valid++
    }
}

END {
    print valid"/"NR
}
