function ceil(x, y) { y=int(x); return (x>y ? y+1 : y) }
function floor(x, y) { y=int(x); return (x<y ? y-1 : y) }

BEGIN {
    FS = ""
    rows = 128
    columns = 8
    maxId = 0
    minId = rows*8+8
}

{
    rowMax = rows-1
    rowMin = 0
    columnMax = columns-1
    columnMin = 0

    for (f=1; f<=NF; f++) {
        switch ($f) {
            case "F":
                rowMax = floor((rowMin+rowMax)/2)
                break
            case "B":
                rowMin = ceil((rowMin+rowMax)/2)
                break
            case "L":
                columnMax = floor((columnMin+columnMax)/2)
                break
            case "R":
                columnMin = ceil((columnMin+columnMax)/2)
                break
        }
    }

    if (rowMax == rowMin && columnMax == columnMin) {
        id = rowMax * 8 + columnMax
        seats[id]++
        if (id > maxId) maxId = id
        if (id < minId) minId = id
        #printf "%d: row %d, column %d\n", id, rowMax, columnMax
    } else {
        print "Invalid boarding pass"
    }
}

END {
    print "Highest ID: " maxId
    for (i=minId; i <= maxId; i++) {
        if (!(i in seats)) {
            print "Missing seat ID: " i
        }
    }
}
