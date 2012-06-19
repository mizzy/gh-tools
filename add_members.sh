#!/bin/sh

thor member:bulk_add --file=$1 --organization=paperboy-all --team=Members --public
thor member:sync --srcorg=paperboy-all --srcteam=Members --destorg=paperboy-sqale --destteam=paperboy
thor member:sync --srcorg=paperboy-all --srcteam=Members --destorg=paperboy-fanic --destteam=paperboy
thor member:sync --srcorg=paperboy-all --srcteam=Members --destorg=paperboy-petit --destteam=paperboy
thor member:sync --srcorg=paperboy-all --srcteam=Members --destorg=paperboy-30days --destteam=paperboy
thor member:sync --srcorg=paperboy-all --srcteam=Members --destorg=paperboy-heteml --destteam=paperboy
thor member:sync --srcorg=paperboy-all --srcteam=Members --destorg=paperboy-app --destteam=paperboy
