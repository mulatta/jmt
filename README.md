# jmt

Bridge between [treefmt](https://github.com/numtide/treefmt) and [jj fix](https://martinvonz.github.io/jj/latest/config/#jj-fix).

## Problem

Nix flakes with treefmt-nix define formatters declaratively, but jj fix requires separate configuration. Maintaining both is tedious and error-prone.

Additionally, jj fix requires tools to read from **stdin** and write to **stdout**, but many formatters (deadnix, ruff --fix) only support in-place file modification.

## Solution

jmt automatically generates jj fix config from your existing treefmt setup:

- **Single source of truth**: Define formatters once in treefmt-nix, use everywhere
- **Smart caching**: Only rebuilds formatter when flake.nix/flake.lock changes
- **stdin/stdout adaptation**: Wraps incompatible tools with temp file workarounds

## Why jj fix?

Unlike traditional formatters that modify files in your working copy:

- **No merge conflicts**: Formatting is applied per-commit, not to working copy
- **Works with `jj absorb`**: Format changes are automatically absorbed into the right commits
- **Clean history**: Each commit is formatted independently, even in stacked PRs

```bash
# Format all commits in current stack
jmt

# Then absorb any other changes - no conflicts!
jj absorb
```

## Usage

```bash
jmt                          # Sync config + run jj fix
jmt --sync                   # Only sync config
jmt --print                  # Print generated config
jmt --list                   # List available formatters
jmt --only=nixfmt,ruff       # Run specific tools only
jmt -- -s @-                 # Pass args to jj fix (format parent)
```

## Install

```nix
{
  inputs.jmt.url = "github:mulatta/jmt";
}
```

```bash
nix run github:mulatta/jmt
```

## stdin/stdout Handling

jj fix requires tools to read stdin and write stdout. jmt handles this automatically:

| Tool Type | Strategy | Example |
| ------------- | ------------------------- | ----------------------------- |
| Native stdin | Pass through | `nixfmt`, `alejandra` |
| Needs flag | Add stdin arg | `yamlfmt -`, `taplo -` |
| In-place only | Temp file wrapper | `deadnix`, `ruff check --fix` |
| Linters | Passthrough (stderr only) | `shellcheck`, `statix` |

Wrapper script pattern for in-place tools:

```bash
t=$(mktemp --suffix=.nix); cat >"$t"; deadnix -e "$t"; cat "$t"; rm "$t"
```

## How it works

1. Build `nix build .#formatter.<system>` (cached by mtime)
1. Extract treefmt.toml path from wrapper script
1. Parse formatters, generate jj fix TOML with stdin-compatible commands
1. Write to `.jj/repo/config.toml`
1. Run `jj fix --include-unchanged-files`

## License

MIT
