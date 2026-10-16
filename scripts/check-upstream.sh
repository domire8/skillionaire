#!/usr/bin/env bash
# Report, per imported skill, whether it changed upstream, locally, or both.
# Exits 1 only when upstream changed; local edits are expected.
#   scripts/check-upstream.sh              status of every skill
#   scripts/check-upstream.sh --diff NAME  local edits against the pinned upstream version
set -euo pipefail
cd "$(dirname "$0")/.."

upstream_of() {
  jq -r --arg s "$1" '.upstreams | to_entries[] | select(.value.skills[$s]) | .key' sources.json
}

if [ "${1:-}" = "--diff" ]; then
  skill=${2:?usage: check-upstream.sh --diff NAME}
  repo=$(upstream_of "$skill")
  path=$(jq -r --arg r "$repo" --arg s "$skill" '.upstreams[$r].skills[$s].path' sources.json)
  commit=$(jq -r --arg r "$repo" '.upstreams[$r].importedCommit' sources.json)
  gh api "repos/$repo/contents/$path?ref=$commit" --jq .content | base64 -d |
    diff -u --label "upstream $repo@${commit:0:7}" --label "local skills/$skill/SKILL.md" - "skills/$skill/SKILL.md" || true
  exit 0
fi

status=0
for repo in $(jq -r '.upstreams | keys[]' sources.json); do
  head=$(gh api "repos/$repo/commits/HEAD" --jq .sha)
  imported=$(jq -r --arg r "$repo" '.upstreams[$r].importedCommit' sources.json)
  echo "$repo: imported ${imported:0:7}, upstream ${head:0:7}"
  for skill in $(jq -r --arg r "$repo" '.upstreams[$r].skills | keys[]' sources.json); do
    path=$(jq -r --arg r "$repo" --arg s "$skill" '.upstreams[$r].skills[$s].path' sources.json)
    pinned=$(jq -r --arg r "$repo" --arg s "$skill" '.upstreams[$r].skills[$s].blob' sources.json)
    upstream=$(gh api "repos/$repo/contents/$path" --jq .sha 2>/dev/null || echo missing)
    file="skills/$skill/SKILL.md"
    local_blob=$(git hash-object "$file")

    state=ok; note=""
    [ "$local_blob" != "$pinned" ] && state="modified locally"
    if [ "$upstream" != "$pinned" ]; then
      [ "$state" = ok ] && state="upstream changed" || state="modified locally + upstream changed"
    fi
    if [ "$local_blob" != "$pinned" ]; then
      if ! git diff --quiet HEAD -- "$file"; then
        note="uncommitted edits"
      else
        note="last changed in $(git log -1 --format=%h -- "$file")"
      fi
    fi
    [ "$upstream" = "$pinned" ] || status=1
    printf '  %-34s %s%s\n' "$skill" "$state" "${note:+ ($note)}"
  done
done
exit $status
