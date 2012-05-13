# gh-tools

Gh-tools are some tiny tools for GitHub.Now support user add/remove/sync function to organization teams.

This command adds user "mizzy" to "Members" team of "paperboy-all" orgnization and pulicizes it.

```
$ thor member:add --user=mizzy --organization=paperboy-all --team=Members --public
```

This command removes user "mizzy" from "Members" team of "paperboy-all" orgnization.

```
$ thor member:remove --user=mizzy --organization=paperboy-all --team=Members
```

This command adds users in members.txt file to "Members" team of "paperboy-all" organization.

```
$ thor member:bulk_add --file=members.txt --organization=paperboy-all --team=Members --public
```

This command syncs members of "Members" team of "paperboy-all" organization to "paperboy" team of "paperboy-sqale" organization.

```
$ thor member:sync --srcorg=paperboy-all --srcteam=Members --destorg=paperboy-sqale --destteam=paperboy
```
