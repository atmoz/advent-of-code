function validateByr(val) {
    return val ~ /^[[:digit:]]{4}$/ && val >= 1920 && val <= 2002
}

function validateIyr(val) {
    return val ~ /^[[:digit:]]{4}$/ && val >= 2010 && val <= 2020
}

function validateEyr(val) {
    return val ~ /^[[:digit:]]{4}$/ && val >= 2020 && val <= 2030
}

function validateHgt(val) {
    if (match(val, /^([[:digit:]]+)cm$/, cap)) {
        return cap[1] >= 150 && cap[1] <= 193
    }
    if (match(val, /^([[:digit:]]+)in$/, cap)) {
        return cap[1] >= 59 && cap[1] <= 76
    }
    return 0
}

function validateHcl(val) {
    return val ~ /^#[a-f0-9]{6}$/
}

function validateEcl(val) {
    return val ~ /^amb|blu|brn|gry|grn|hzl|oth$/
}

function validatePid(val) {
    return val ~ /^[[:digit:]]{9}$/
}

BEGIN {
    FS = "\n\n"
    RS = ""
    valid = 0
}

{
    split("", fields)
    split($0, pairs, " ")

    for (p in pairs) {
        split(pairs[p], part, ":")
        fields[part[1]] = part[2]
    }

    validateByr(fields["byr"]) && \
    validateIyr(fields["iyr"]) && \
    validateEyr(fields["eyr"]) && \
    validateHgt(fields["hgt"]) && \
    validateHcl(fields["hcl"]) && \
    validateEcl(fields["ecl"]) && \
    validatePid(fields["pid"]) && \
    valid++
}

END {
    print "Number of valid passports: " valid
}
