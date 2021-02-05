## usage: change_base(number, start_base, end_base)
## converts "number" from "start_base" to "end_base"
## bases must be between 2 and 64. the digits greater than 9 are represented
## by the lowercase letters, the uppercase letters, @, and _, in that order.
## if ibase is less than or equal to 36, lowercase and uppercase letters may
## be used interchangeably to represent numbers between 10 and 35.
## returns 0 if any argument is invalid
function change_base(num, ibase, obase,
                     chars, c, l, i, j, cur, b10, f, fin, isneg) {
  # convert number to lowercase if ibase <= 36
  if (ibase <= 36) {
    num = tolower(num);
  }

  # determine if number is negative. if so, set isneg=1 and remove the '-'
  if (sub(/^-/, "", num)) {
    isneg = 1;
  }

  # determine if inputs are valid
  if (num ~ /[^[:xdigit:]]/ || ibase != int(ibase) || obase != int(obase) ||
      ibase < 2 || ibase > 64 || obase < 2 || obase > 64) {
    return 0;
  }

  # set letters to numbers conversion array
  if (ibase > 10 || obase > 10) {
    # set chars[] array to convert letters to numbers
    c = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ@_";
    l = length(c);

    j = 10;
    for (i=1; i<=l; i++) {
      cur = substr(c, i, 1);
      chars[cur] = j;
      chars[j] = cur;

      j++;
    }
  }
  
  # convert to base 10
  if (ibase != 10) { 
    l = length(num);

    j = b10 = 0;
    for (i=l; i>0; i--) {
      c = substr(num, i, 1);

      # if char is a non-digit convert to dec
      if (c !~ /^[0-9]$/) {
        c = chars[c];
      }

      # check to make sure value isn't too great for base
      if (+c >= ibase) {
        return 0;
      }

      b10 += c * (ibase ^ j++);
    }
  } else {
    # num is already base 10
    b10 = num;
  }
  
  # convert from base 10 to obase
  if (obase != 10) {
    # build number backwards
    j = 0;
    do {
      f[++j] = (c = b10 % obase) > 9 ? chars[c] : c;
      b10 = int(b10 / obase);
    } while (b10);

    # reverse number
    fin = f[j];
    for (i=j-1; i>0; i--) {
      fin = fin f[i];
    }
  } else {
    # num has already been converted to base 10
    fin = b10;
  }

  # add '-' if number was negative
  if (isneg) {
    fin = "-" fin;
  }

  return fin;
}

{
    if (match($0, /^(mask|mem)\[*([0-9]*)\]*\s*=\s*(.+)$/, cap)) {
        op = cap[1]
        address = cap[2]
        value = cap[3]

        if (part == 1) {
            if (op == "mask") {
                zero_mask = value
                gsub(/0/, "#", zero_mask)
                gsub(/1/, "0", zero_mask)
                gsub(/#/, "1", zero_mask)
                gsub(/X/, "0", zero_mask)
                one_mask = value
                gsub(/X/, "0", one_mask)
                zero_mask = change_base(zero_mask, 2, 10)
                one_mask = change_base(one_mask, 2, 10)
            } else {
                mem[address] = or(and(value, xor(value, zero_mask)), one_mask)
                printf "mem[%s] = %s\n", address, change_base(mem[address], 10, 2)
            }
        } else {
            if (op == "mask") {
                xs = (split(value, _, "X") - 1) ^ 2
                zero_mask[1] = zero_mask[2] = value
                gsub(/0/, "#", zero_mask)
                gsub(/1/, "0", zero_mask)
                gsub(/#/, "1", zero_mask)
                gsub(/X/, "0", zero_mask)
                one_mask[1] = one_mask[2] = value
                gsub(/X/, "0", one_mask)
                zero_mask = change_base(zero_mask, 2, 10)
                one_mask = change_base(one_mask, 2, 10)
            } else {
            }
        }
    }
}

END {
    print "#################################################33"
    for (m in mem) {
        printf "mem[%s] = %s\n", m, mem[m]
        sum += mem[m]
    }

    print "Sum = " sum
}
