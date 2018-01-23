#!/bin/bash

./balances.pl n | perl -lnae '$_=$F[7]; next if $_ eq 'Balance'; s/^-\$//; print' | paste -sd+ - | bc
./balances.pl n | grep -v Balance | wc -l
