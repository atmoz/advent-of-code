#!/bin/bash

numbers="$(sort -n input)"

for one in $numbers; do
    for two in $numbers; do
        if ((one+two==2020)); then
            echo "$one + $two = 2020"
            echo "$one * $two = $((one*two))"
        fi
        for three in $numbers; do
            if ((one+two+three==2020)); then
                echo "$one + $two + $three = 2020"
                echo "$one * $two * $three = $((one*two*three))"
                exit 0
            fi
        done
    done
done
