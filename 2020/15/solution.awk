function nextNumber(turn, prev) {
    if (prev in reg) {
        if (debug) print "found in reg[" prev "] == " reg[prev]
        at = reg[prev]
        if (debug) print "reg[" turn - at "] = " turn
        reg[turn - at] = turn
        #delete reg[prev]
        delete ns[turn]
        return turn - at
        #diff = turn - reg[prev]
        #return (diff > 0 ? diff : 1)
    } else if (prev in ns) {
        reg[prev] = turn
        return 0
    }

    if (debug) print "not found in reg: " prev

    reg[prev] = turn
    return 0
    #for (l=turn-1; l>=1; l--) {
    #    if (ns[l] == prev) {
    #        return turn - l
    #    }
    #}
    #return 0
}

BEGIN { RS = "," }

{
    n = int($0)
    ns[NR] = n
    i++
    #if (debug) printf "ns[%d] = %d\n", NR, ns[NR]
}

END {
    for (i=i; i < (part == 1 ? 2020 : 30000000); i++) {
        #if (debug) print "OK, next index up: " i " with value '" ns[i] "'"
        ns[i+1] = nextNumber(i, ns[i])
        #n = nextNumber(i, n)
        #reg[ns[i]] = i
        #if (debug) printf "ns[%d] = %d\n", i+1, ns[i+1]
    }
    print "Number = " n #ns[length(ns)]
}
