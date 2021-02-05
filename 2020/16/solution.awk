BEGIN { FS = ":|,|-| or " }

/^[a-z ]+:\s*[0-9-]+/ {
    for (f=2; f<=NF; f += 2) {
        rules[$1][f/2]["from"] = int($f)
        rules[$1][f/2]["to"] = int($(f+1))
        if (debug) print $1 " from " int($f) " to " int($(f+1))
    }
}

/^[a-z ]+:\s*$/ {
    heading = $1
    if (debug) print "heading = " heading
}

/^[0-9,]+$/ {
    for (f=1; f<=NF; f++) {
        if (heading == "your ticket") {
            ticket[f] = $f
            if (debug) printf "ticket[%d] = %d\n", f, $f
        } else {
            nearby[NR][f] = $f
            if (debug) printf "nearby[%d][%d] = %d\n", NR, f, $f
        }
    }
}

END {
    for (n in nearby) {
        for (nf in nearby[n]) {
            num = nearby[n][nf]
            ok = 0
            for (r in rules) {
                for (rf in rules[r]) {
                    if (num >= rules[r][rf]["from"] && num <= rules[r][rf]["to"]) {
                        fields[r][nf]++
                        ok++
                    } else {
                        fields[r][nf]--
                    }
                }
            }
            if (ok == 0) {
                if (debug) print "invalid num: " num
                invalid[++i] = num
                if (part == 2) {
                    if (debug) print "delete ticket " n
                    delete nearby[n]
                    break
                }
            }
        }
    }

    sum = 0
    for (i in invalid) {
        sum += invalid[i]
    }

    print "Part 1: ticket scanning error rate: " sum


    PROCINFO["sorted_in"] = "@val_num_desc"
    for (f in fields) {
        for (nf in fields[f]) {
            if (fields[f][nf] < 0) {
                for (nff in fields[f]) {
                    if (nff != nf && fields[f][nff] >= 0) fields[f][nff]++
                }
                delete fields[f][nf]
            }
        }
    }

    while (length(fields) > 0) {
        for (f in fields) {
            if (debug) print "field: " f
            if (length(fields[f]) == 1) {
                # set location
                for (nf in fields[f]) {
                    location[f] = nf
                }
                # cleanup location
                delete fields[f]
                for (ff in fields) {
                    delete fields[ff][location[f]]
                }
            } else {
                for (nf in fields[f]) {
                    if (f in location) {
                        # TODO ......
                    }
                }
            }
        }
    }

    part2 = 0
    for (l in location) {
        print "location " l ": " location[l]
        if (l ~ /^departure /) {
            print "departure value: " location[l]
            part2 *= location[l]
        }
    }

    print "Part 2: " part2
}
