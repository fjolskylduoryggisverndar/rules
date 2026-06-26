#!/usr/bin/env bash
#
# Generate the sing-box rule-set folders by downloading the prebuilt parser
# binaries from the `tools` repo and running them. Pure bash — no Go toolchain.
#
# Outputs (committed to this repo's master branch):
#   rule-set-geosite/geosite-<code>.srs  + .json
#   rule-set-geoip/geoip-<code>.srs      + .json
#
# The binaries are linux/amd64; this script is meant to run on the CI runner.

set -euo pipefail

TOOLS_RELEASE="https://github.com/fjolskylduoryggisverndar/tools/releases/latest/download"
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

echo "==> Downloading parser binaries from tools/latest"
curl -fSL --retry 3 -o "$WORK/sing-geosite" "$TOOLS_RELEASE/sing-geosite-linux-amd64"
curl -fSL --retry 3 -o "$WORK/sing-geoip"   "$TOOLS_RELEASE/sing-geoip-linux-amd64"
chmod +x "$WORK/sing-geosite" "$WORK/sing-geoip"

echo "==> Generating geosite rule-set"
mkdir -p "$WORK/geosite"
( cd "$WORK/geosite" && NO_SKIP=true "$WORK/sing-geosite" )

echo "==> Generating geoip rule-set"
mkdir -p "$WORK/geoip"
( cd "$WORK/geoip" && NO_SKIP=true "$WORK/sing-geoip" )

echo "==> Refreshing rule-set folders"
rm -rf "$ROOT/rule-set-geosite" "$ROOT/rule-set-geoip"
mkdir -p "$ROOT/rule-set-geosite" "$ROOT/rule-set-geoip"
cp -a "$WORK/geosite/rule-set/." "$ROOT/rule-set-geosite/"
cp -a "$WORK/geoip/rule-set/."   "$ROOT/rule-set-geoip/"

echo "==> Done:"
echo "    rule-set-geosite: $(find "$ROOT/rule-set-geosite" -type f | wc -l | tr -d ' ') files"
echo "    rule-set-geoip:   $(find "$ROOT/rule-set-geoip"   -type f | wc -l | tr -d ' ') files"
