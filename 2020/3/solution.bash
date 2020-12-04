#!/bin/bash

awk -f solution.awk -v dx=1 -v dy=1 input
awk -f solution.awk -v dx=3 -v dy=1 input
awk -f solution.awk -v dx=5 -v dy=1 input
awk -f solution.awk -v dx=7 -v dy=1 input
awk -f solution.awk -v dx=1 -v dy=2 input
