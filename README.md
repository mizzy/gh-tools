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

----

# ペパボの人向け README

## paperboy-all 入りたい！

paperboy-all に入りたい方は、GitHub アカウント名を mizzy, hsbt, antipop のいずれかへお知らせください。

または、[paperboy-all/gh-tools](https://github.com/paperboy-all/gh-tools) の members.txt に GitHub アカウント名を追記して pullreq してください。(mizzy/gh-tools の方ではないのでご注意を。)

paperboy-all に入ると、他のペパボ組織アカウント(paperboy-fanic, paperboy-sqale など)内の情報を参照できるようになります。

## 管理者向け

ペパボ組織アカウントすべての Owners に所属してる人は、以下のように実行することで、members.txt 内のユーザを、paperboy-all に追加し、さらに各ペパボ組織アカウントの Pull Only なチームに同期することができます。

```
$ ./add_members.sh members.txt
```

アカウントの追加依頼や、追加 pullreq が来たら、このコマンドで対応してください。
