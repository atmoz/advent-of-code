BEGIN {
    FS = "\n\n"
    RS = ""
}

{
    split($0, members, "\n")
    memberCount[NR] = length(members)
    for (m in members) {
        split(members[m], questions, "")
        for (q in questions) {
            memberResult[NR,m,questions[q]] = 1 # ignores duplicates
            totalResult[NR,questions[q]]++
            #printf "g %d, q %s\n", NR, questions[q]
        }
    }
}

END {
    for (combined in memberResult) { # Count questions per group
        split(combined, key, SUBSEP)
        groupResult[key[1],key[3]]++
    }

    for (combined in groupResult) { # Count questions everyone answered in group
        split(combined, key, SUBSEP)
        if (groupResult[combined] == memberCount[key[1]]) {
            everyoneNum++
        }
    }

    print "Part 1: total number of questions answered yes: " length(totalResult)
    print "Part 2: number of questions everyone answered yes: " everyoneNum
}
