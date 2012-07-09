#!/bin/sh

thor member:bulk_add --file=$1 --organization=paperboy-all --team=paperboy --public
thor member:sync --srcorg=paperboy-all --srcteam=paperboy --destorg=paperboy-sqale --destteam=paperboy
thor member:sync --srcorg=paperboy-all --srcteam=paperboy --destorg=paperboy-fanic --destteam=paperboy
thor member:sync --srcorg=paperboy-all --srcteam=paperboy --destorg=paperboy-petit --destteam=paperboy
thor member:sync --srcorg=paperboy-all --srcteam=paperboy --destorg=paperboy-30days --destteam=paperboy
thor member:sync --srcorg=paperboy-all --srcteam=paperboy --destorg=paperboy-heteml --destteam=paperboy
thor member:sync --srcorg=paperboy-all --srcteam=paperboy --destorg=paperboy-app --destteam=paperboy
thor member:sync --srcorg=paperboy-all --srcteam=paperboy --destorg=paperboy-ec-shien --destteam=paperboy
thor member:sync --srcorg=paperboy-all --srcteam=paperboy --destorg=paperboy-minne --destteam=paperboy
thor member:sync --srcorg=paperboy-all --srcteam=paperboy --destorg=paperboy-jugemcart --destteam=paperboy
thor member:sync --srcorg=paperboy-all --srcteam=paperboy --destorg=paperboy-muumuu-domain --destteam=paperboy
thor member:sync --srcorg=paperboy-all --srcteam=paperboy --destorg=paperboy-kyoto --destteam=paperboy
