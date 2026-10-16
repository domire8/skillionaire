#!/usr/bin/env bash
# Compare each imported SKILL.md against its upstream blob and report drift.
set -euo pipefail
cd "$(dirname "$0")/.."

status=0
for repo in $(jq -r '.upstreams | keys[]' sources.json); do
  head=$(gh api "repos/$repo/commits/HEAD" --jq .sha)
  imported=$(jq -r --arg r "$repo" '.upstreams[$r].importedCommit' sources.json)
  echo "$repo: imported ${imported:0:7}, upstream ${head:0:7}"
  for skill in $(jq -r --arg r "$repo" '.upstreams[$r].skills | keys[]' sources.json); do
    path=$(jq -r --arg r "$repo" --arg s "$skill" '.upstreams[$r].skills[$s].path' sources.json)
    pinned=$(jq -r --arg r "$repo" --arg s "$skill" '.upstreams[$r].skills[$s].blob' sources.json)
    current=$(gh api "repos/$repo/contents/$path" --jq .sha 2>/dev/null || echo missing)
    if [ "$current" = "$pinned" ]; then
      echo "  ok       $skill"
    else
      echo "  changed  $skill ($current)"
      status=1
    fi
  done
done
exit $status
