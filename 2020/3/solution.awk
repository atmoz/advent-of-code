BEGIN {
    x = 0
    y = 0
    trees = 0
}

{
    if (NR-1 == y + dy) {
        split($0, chars, "")
        l = length($0)
        x = (x + dx) % l
        y = y + dy

        row = ""
        for (c in chars) {
            if (c-1 == x) {
                if (chars[c] == "#") {
                    row = row "X"
                    trees++
                } else {
                    row = row "O"
                }
            } else {
                row = row chars[c]
            }
        }

        #print row
    } else {
        #print $0
    }
}

END {
    print "Number of trees with dx="dx",dy="dy": " trees
}
