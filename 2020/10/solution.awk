{ as[NR] = $1 }

END {
    PROCINFO["sorted_in"] = "@val_num_asc"
    adapters[0] = 0 # charging outlet
    for (a in as) { # sorted array order
        adapters[++i] = as[a]
    }

    j = 0
    for (i in adapters) {
        for (a in adapters) {
            ja = int(adapters[a])
            if (ja > j && ja <= j+3) {
                ds[ja-j]++
                j = ja
                break
            }
        }
    }

    ds[3]++ # count built-in adapter
    for (d in ds) {
        print d " = " ds[d]
    }
    print "Part 1: " ds[1]*ds[3]

    c[0] = 1
    for (a=0; a<=length(adapters); a++) {
        if (!(a in adapters)) continue
        ja = int(adapters[a])
        for (b=a+1; b<=a+4 && b<=length(adapters); b++) {
            if (!(b in adapters)) continue
            jb = int(adapters[b])
            if (jb-ja <= 3) {
                c[b] += c[a]
            }
        }
    }

    print "Part 2: " c[length(c)-1]


}
