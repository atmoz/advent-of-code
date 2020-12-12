function get(x, y) {
    if (x in g && y in g[x]) {
        return g[x][y]
    }
    return "."
}

function set(x, y, v) {
    if (x in g && y in g[x]) {
        b[x][y] = v
        changes++
    }
}

function adjacent(x, y) {
    return get(x,y-1) get(x-1,y) get(x-1,y-1) get(x-1,y+1) \
           get(x,y+1) get(x+1,y) get(x+1,y+1) get(x+1,y-1)
}

function visible(x, y) {
    return see(x,y,0,-1) see(x,y,-1,0) see(x,y,-1,-1) see(x,y,-1,+1) \
           see(x,y,0,+1) see(x,y,+1,0) see(x,y,+1,+1) see(x,y,+1,-1)
}

function see(x, y, dx, dy) {
    x += dx
    y += dy
    while (x in g && y in g[x]) {
        if (g[x][y] != ".") {
            return g[x][y]
        }
        x += dx
        y += dy
    }
}

function empty(seats, _result) {
    split(seats, _result, "L")
    return length(_result) - 1
}

function occupied(seats, _result) {
    split(seats, _result, "#")
    return length(_result) - 1
}

BEGIN { FS = "" }

{
    for (f=1; f<=NF; f++) {
        g[NR][f] = $f # grid
        b[NR][f] = $f # buffer
    }
}

END {
    while (r++ == 0 || changes) {
        if (r > 1000) exit
        changes = 0

        for (x in g) {
            for (y in g[x]) {
                if (part == 1) {
                    if (empty(get(x,y)) && occupied(adjacent(x,y)) == 0) {
                        set(x,y,"#")
                    } else if (occupied(get(x,y)) && occupied(adjacent(x,y)) >= 4) {
                        set(x,y,"L")
                    }
                } else if (part == 2) {
                    if (empty(get(x,y)) && occupied(visible(x,y)) == 0) {
                        set(x,y,"#")
                    } else if (occupied(get(x,y)) && occupied(visible(x,y)) >= 5) {
                        set(x,y,"L")
                    }
                }
            }
        }

        for (x in g) {
            for (y in g[x]) {
                g[x][y] = b[x][y] # flush buffer
            }
        }
    }

    for (x in g) {
        for (y in g[x]) {
            if (occupied(g[x][y])) o++
        }
    }

    printf "\n%d occupied seats\n", o
}
