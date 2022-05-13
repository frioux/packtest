#!/bin/sh

size=1000000
versions=500

for i in $(seq 1 $versions); do
        seq $i $(($size + $i)) > seq.txt
        git add seq.txt
        git commit -m 'herp'
done
