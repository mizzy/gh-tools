#!/bin/sh

while read USER; do
    echo $USER
    thor member:add --user=$USER --organization=paperboy-all --team=Members --public
done <"members.txt"

thor member:sync --srcorg=paperboy-all --srcteam=Members --destorg=paperboy-sqale --destteam=paperboy
