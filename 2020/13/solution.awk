## usage: gcd(a, b)
## returns the greatest common denominator (greatest common factor) of a and b.
## both a and b must be positive integers. uses the recursive euclid algorithm.
function gcd(a, b,    f) {
  # check to make sure both numbers are positive ints
  if (!f) {
    if (a !~ /^[0-9]+$/ || !a || b !~ /^[0-9]+$/ || !b) {
      return 0;
    }
  }

  if (b) {
    return gcd(b, a % b, 1);

  } else {
    # return the absolute value
    return a < 0 ? -a : a;
  }
}

## usage: lcm(a, b)
## returns the least common multiple of a and b. both a and b must be positive
## integers.
function lcm(a, b,    m, l) {
  # check to make sure both numbers are positive ints
  if (a !~ /^[0-9]+$/ || !a || b !~ /^[0-9]+$/ || !b) {
    return 0;
  }

  m = 0;
  while ((l = ++m * a) % b);

  return l;
}

function depart_after(loop, after) {
    return loop*((after-after%loop)/loop)+loop
}

BEGIN { RS="\n|," }

{
    if (NR == 1) from = int($0)
    else bus[NR-1] = $0
}

END {
    #c = bus[1]
    #for (b=2; b<=length(bus); b++) {
    #    if (bus[b] == "x") continue
    #    print lcm(bus[b], bus[1]) " " gcd(bus[b], bus[1])
    #}
    ##print "c: " c
    #exit


    PROCINFO["sorted_in"] = "@val_num_asc"
    for (b in bus) {
        if (bus[b] == "x") continue
        start[b] = depart_after(bus[b], from)
        if (first == 0 || start[b] < start[first]) first = b
        if (debug) print bus[b] " => " start[b]
    }

    if (part == 1) {
        print "Part 1"
        id = bus[first]
        time = start[first]
        wait = time - from
        printf "Earliest bus ID %d starts %d, you must wait %d min\n", id, time, wait
        printf "Multiply = %d\n", id * wait
    } else {
        print "Part 2"
        #solved = 0
        #for (t=bus[1]; !solved; t+=bus[1]) {
        #    #print ""
        #    #print t" bus "bus[1]
        #    solved = 1
        #    for (b=2; b<=length(bus); b++) {
        #        time_req=t+b-1
        #        if (bus[b] == "x") {
        #            #print time_req" free slot"
        #            continue
        #        }
        #        dep = depart_after(bus[b], time_req-1)
        #        #printf "%d bus %d\n", dep, bus[b]
        #        if (dep != time_req) {
        #            solved = 0
        #            #print "NOPE"
        #            break # no luck, try next t
        #        }
        #    }
        #    if (solved) solution = t
        #    #if (t == 1068781) break
        #}
        #print ""
        #print "Time = " solution
        #

        c = gcd(bus[1], bus[length(bus)])
        solved = 0
        while (!solved) {
            r += c
            first = bus[1] * r
            last = first + length(bus) - 1
            dep = depart_after(bus[length(bus)], last) - bus[length(bus)]
            if (debug) printf "first:%d last:%d dep:%d\n", first, last, dep
            if (dep != last) {
                continue
                #print dep
                #break
            }

            solved = 1 # finding out if it's not
            t=first
            if (debug) print ""
            if (debug) print t" bus "bus[1]
            for (b=2; b<=length(bus); b++) {
                time_req=t+b-1
                if (bus[b] == "x") {
                    if (debug) print time_req" free slot"
                    continue
                }
                dep = depart_after(bus[b], time_req-1)
                if (debug) printf "%d bus %d\n", dep, bus[b]
                if (dep != time_req) {
                    solved = 0
                    if (debug) print "NOPE"
                    break # no luck, try next t
                }
            }
            if (solved) solution = t


            #if (first == 1068781) break
        }

        print ""
        print "Time = " solution
    }
}
