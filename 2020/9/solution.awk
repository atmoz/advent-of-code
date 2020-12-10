{
    num[NR] = $1
    if (NR > keysize) {
        for (n1 = NR-keysize; n1 < NR; n1++) {
            for (n2 = NR-keysize; n2 < NR; n2++) {
                if (num[n1] != num[n2] && num[n1] + num[n2] == $1) next
            }
        }
        invalid = $1
        print "Part 1: Number " $1 " is not valid"
        exit
    }
}

END {
    for (n1 = 1; n1 < length(num); n1++) {
        sum = num[n1]
        from = to = n1
        large = small = num[n1]
        for (n2 = n1+1; n2 < length(num); n2++) {
            sum += num[n2]
            to = n2
            if (num[n2] > large) large = num[n2]
            if (num[n2] < small) small = num[n2]
            if (sum > invalid) break
            if (sum == invalid) {
                printf "Part 2: Encryption weakness = %d (%d and %d) sum %d\n", small + large, small, large, sum
                exit
            }
        }
    }
}
