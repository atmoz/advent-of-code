function abs(v) { return v < 0 ? -v : v }

# GAWK uses "truncated division"
# https://www.gnu.org/software/gawk/manual/html_node/Arithmetic-Ops.html
# https://en.wikipedia.org/wiki/Modulo_operation#Variants_of_the_definition
function mod(a,b) {
    r = a % b
    return r < 0 ? b+r : r # avoid negative results
}

function set_waypoint(newx, newy) {
    wx = newx
    wy = newy
}

function rotate_waypoint(deg, dir) {
    switch (deg) {
        case 90:  set_waypoint(wy*dir, -wx*dir); break
        case 180: set_waypoint(-wx,-wy); break
        case 270: set_waypoint(-wy*dir,wx*dir); break
    }
}

BEGIN {
    split("NESW", dmap, "")
    d = 1
    x = y = 0
    wx = 10
    wy = -1
}

{
    match($0, /^([NSEWLRF]{1})([0-9]+)$/, cap)
    act = cap[1]
    val = cap[2]
    printf $0" >>> "act":"val

    if (part == 1) {
        if (act == "F") {
            act = dmap[d]
            printf " -> "act":"val
        }
        switch (act) {
            case "N": y -= val; break
            case "S": y += val; break
            case "E": x += val; break
            case "W": x -= val; break
            case "R": d = 1 + mod(d + (val / 90), 4); break
            case "L": d = 1 + mod(d - (val / 90), 4); break
        }
    } else {
        if (act == "F") {
            x += wx * val
            y += wy * val
            printf $0" >>> "act":"val
        }
        switch (act) {
            case "N": wy -= val; break
            case "S": wy += val; break
            case "E": wx += val; break
            case "W": wx -= val; break
            case "R": rotate_waypoint(val, -1); break
            case "L": rotate_waypoint(val, 1); break
        }
    }

    print " ("x","y") ("wx","wy") d="d
}

END {
    printf "abs(%d) + abs(%d) = %d\n", x, y, abs(x)+abs(y)
}
