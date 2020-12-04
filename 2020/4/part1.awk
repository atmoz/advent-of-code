BEGIN {
    FS = "\n\n"
    RS = ""
    split("byr,iyr,eyr,hgt,hcl,ecl,pid", req, ",")
    valid = 0
}

{
    split("", has)
    split($0, fields, " ")

    for (f in fields) {
        split(fields[f], pair, ":")
        has[pair[1]]++
    }

    for (r in req) {
        if (!(req[r] in has)) {
            next
        }
    }

    valid++
}

END {
    print "Number of valid passports: " valid
}
