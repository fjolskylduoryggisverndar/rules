# rules

sing-box Geoip & Geosite rule-sets (enhanced, derived from
[Loyalsoldier](https://github.com/Loyalsoldier) data), refreshed daily by CI.

The compiled rule-sets live in two folders on the `master` branch:

- [`rule-set-geoip/`](rule-set-geoip) — `geoip-<code>.srs` + `geoip-<code>.json`
- [`rule-set-geosite/`](rule-set-geosite) — `geosite-<code>.srs` + `geosite-<code>.json`

Point your sing-box config at a raw URL, e.g.:

```
https://raw.githubusercontent.com/fjolskylduoryggisverndar/rules/master/rule-set-geoip/geoip-cn.srs
https://raw.githubusercontent.com/fjolskylduoryggisverndar/rules/master/rule-set-geosite/geosite-cn.srs
```

## How it works

This repo holds no parsing logic. The heavy lifting (parsing the v2ray
`geosite.dat` protobuf and the MaxMind `Country.mmdb`) lives in the
[`tools`](https://github.com/fjolskylduoryggisverndar/tools) repo, which
publishes prebuilt `linux/amd64` binaries on a rolling `latest` release.

[`build.sh`](build.sh) downloads those binaries, runs them to regenerate the
rule-sets, and the `update` workflow commits the two folders back to `master`.
It runs on push, on manual dispatch, and daily at 01:00 UTC.

`build.sh` downloads `linux/amd64` binaries, so run it on the CI runner (or any
linux/amd64 host).
