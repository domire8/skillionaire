# skillionaire

A small personal set of agent skills for Claude Code.

| Skill | What it does |
|---|---|
| `bro` | Restates the last message in plain language, no jargon. |
| `readback` | Restates a request so you can confirm alignment before work starts. |
| `handoff` | Compacts the conversation into a handoff document for another agent. |
| `big-pics-little-words` | Explains the current subject in HTML with big visuals and few words. |
| `clean-room` | Gets an independent decision from a fresh agent that sees none of the conversation. |

## Install as a plugin

```
/plugin marketplace add domire8/skillionaire
/plugin install skillionaire@skillionaire
```

For local development, point the marketplace at the checkout instead:
`/plugin marketplace add ~/git/skillionaire`.

## Provenance

Every skill is imported from an upstream repository at the commit pinned in
`sources.json`, together with each file's upstream blob hash:

- `bro` from [cursor/plugins](https://github.com/cursor/plugins/tree/main/pstack) (pstack)
- `handoff` from [mattpocock/skills](https://github.com/mattpocock/skills) (MIT, see `THIRD_PARTY_NOTICES.md`)
- the other three from [backnotprop/bro](https://github.com/backnotprop/bro)

Run `scripts/check-upstream.sh` (needs `gh` and `jq`) to see which skills
changed upstream since the import.

The pstack and backnotprop repositories have no license file, so `bro`,
`readback`, `big-pics-little-words` and `clean-room` are copied without
an explicit license. They are kept here at the owner's risk; if an author asks,
they will be removed.
