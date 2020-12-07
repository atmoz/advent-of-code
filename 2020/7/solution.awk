function countBagsContaining(targetBag, _child, _count) {
    if (_child) {
        if (!isarray(rules[_child])) {
            return 0
        }
        for (r in rules[_child]) {
            if (rules[_child][r]["bag"] == targetBag) {
                _count++
                break
            } else {
                _count += countBagsContaining(targetBag, rules[_child][r]["bag"])
            }
        }
    } else {
        for (bag in rules) {
            _count += (countBagsContaining(targetBag, bag) ? 1 : 0)
        }
    }
    return _count
}

function countBagsInside(targetBag, _count) {
    if (!isarray(rules[targetBag])) {
        return 0
    }
    for (r in rules[targetBag]) {
        _count += rules[targetBag][r]["count"] * (1+countBagsInside(rules[targetBag][r]["bag"]))
    }
    return _count
}

{
    if (match($0, /^(.+) bags contain (.+).$/, cap)) {
        bag = cap[1]
        split(cap[2], contain, ", ")
        for (c in contain) {
            if (match(contain[c], /^([0-9]+) (.+) bags?$/, cap)) {
                rules[bag][c]["count"] = cap[1]
                rules[bag][c]["bag"] = cap[2]
            }
        }
    }
}

END {
    print "Bags containing shiny gold: " countBagsContaining("shiny gold")
    print "Number of bags inside shiny gold: " countBagsInside("shiny gold")
}
