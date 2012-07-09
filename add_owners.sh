#!/bin/sh

owners="mizzy kentaro hsbt"
orgs="all sqale fanic petit 30days heteml app ec-shien minne jugemcart muumuu-domain kyoto"

for owner in $owners
do
    for org in $orgs
    do
        thor member:add --user=$owner --organization=paperboy-$org --team=Owners
    done
done
