#!/bin/sh

thor member:bulk_add --file=$1 --organization=paperboy-all --team=Members --public
thor member:sync --srcorg=paperboy-all --srcteam=Members --destorg=paperboy-sqale --destteam=paperboy
