function reset() {
    print "Reset at " i
    i = 1
    acc = 0
    hacked = 0
    for (ii in ins) {
        ins[ii]["run"] = 0
    }
}

function jmp() {
    i += ins[i]["arg"]
    if (i < 1) i = 1
    if (i > max) i = max
}

function hack() {
    if (part != 1 && !hacked && !ins[i]["hacked"]) {
        hacked = 1
        ins[i]["hacked"] = 1
        return 1
    }
    return 0
}

{
    ins[NR]["op"] = $1
    ins[NR]["arg"] = $2
    ins[NR]["run"] = 0
    ins[NR]["hacked"] = 0
    max = NR
}

END {
    i = 1
    while (1) {
        if (ins[i]["run"]++ > 0) { # detect loop
            printf "Loop at %d with ACC %d\n", i, acc
            if (hacked) {
                reset()
                continue
            }
            break
        }

        if (ins[i]["op"] == "jmp") {
            if (!hack()) {
                jmp()
                continue
            }
        }

        if (ins[i]["op"] == "nop") {
            if (hack()) {
                jmp()
                continue
            }
        }

        if (ins[i]["op"] == "acc") {
            acc += ins[i]["arg"]
        }

        if (++i >= max) { # end of program
            printf "End of program with ACC %d\n", acc
            break
        }
    }
}
