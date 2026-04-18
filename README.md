# shiny_json_logic ✨

[![Shards](https://img.shields.io/badge/shards-shiny__json__logic-purple)](https://shards.info/github/luismoyano/shiny_json_logic_crystal)
[![Crystal](https://img.shields.io/badge/crystal-%3E%3D%201.0-black)](https://crystal-lang.org)
[![License: MIT](https://img.shields.io/badge/license-MIT-green)](LICENSE)
[![GitHub Clones](https://img.shields.io/badge/dynamic/json?color=success&label=Clone&query=count&url=https://gist.githubusercontent.com/luismoyano/GIST_ID/raw/clone.json&logo=github)](https://github.com/luismoyano/shiny_json_logic_crystal)

> **The most compliant Crystal implementation of JSON Logic. ✨**

**shiny_json_logic** is a **pure Crystal**, **zero-dependency** JSON Logic implementation — the only Crystal shard that passes 100% of the official JSON Logic tests.

This is the Crystal port of [shiny_json_logic](https://rubygems.org/gems/shiny_json_logic), the most compliant Ruby implementation of JSON Logic.

---

## Why shiny_json_logic?

- ✅ **100% spec-compliant** — passes all 613 official JSON Logic tests.
- 🧩 **Zero runtime dependencies** — stdlib only. Just add the shard.
- ⚡ **Native Crystal performance** — compiled, type-safe, fast.
- 🔁 **Drop-in aliases**: `JsonLogic` and `JSONLogic` available out of the box.
- 🔧 **Actively maintained** and aligned with the evolving JSON Logic specification.

---

## Installation

Add to your `shard.yml`:

```yaml
dependencies:
  shiny_json_logic:
    github: luismoyano/shiny_json_logic_crystal
```

Then run:

```bash
shards install
```

---

## Usage

```crystal
require "shiny_json_logic"

# Basic evaluation
ShinyJsonLogic.apply(JSON.parse(%({"==" : [1, 1]})))
# => true

# With data
rule = JSON.parse(%({"var" : "name"}))
data = JSON.parse(%({"name" : "Luis"}))
ShinyJsonLogic.apply(rule, data)
# => "Luis"

# Feature flag example
rule = JSON.parse(%({"==" : [{"var": "plan"}, "premium"]}))
data = JSON.parse(%({"plan": "premium"}))
ShinyJsonLogic.apply(rule, data)
# => true
```

### Nested logic

Rules can be nested arbitrarily:

```crystal
rule = JSON.parse(%(
  {"if": [{"var": "financing"}, {"missing": ["apr"]}, []]}
))
data = JSON.parse(%({"financing": true}))

ShinyJsonLogic.apply(rule, data)
# => ["apr"]
```

### Drop-in aliases

`JsonLogic` and `JSONLogic` are available as aliases:

```crystal
JsonLogic.apply(JSON.parse(%({">" : [{"var": "score"}, 90]})), JSON.parse(%({"score": 95})))
# => true
```

---

## Supported operators

| Category | Operators |
|----------|-----------|
| Data access | `var`, `missing`, `missing_some`, `exists`, `val` ✨ |
| Logic | `if`, `?:`, `and`, `or`, `!`, `!!` |
| Comparison | `==`, `===`, `!=`, `!==`, `>`, `>=`, `<`, `<=` |
| Arithmetic | `+`, `-`, `*`, `/`, `%`, `max`, `min` |
| String | `cat`, `substr` |
| Array | `map`, `filter`, `reduce`, `all`, `none`, `some`, `merge`, `in` |
| Coalesce | `??` ✨ |
| Error handling | `throw`, `try` ✨ |
| Utility | `preserve` ✨ |

✨ = community-extended operators beyond the core spec.

---

## Error handling

shiny_json_logic uses native Crystal exceptions:

```crystal
# Unknown operators raise an error
ShinyJsonLogic.apply(JSON.parse(%({"unknown_op": [1, 2]})))
# => raises ShinyJsonLogic::Errors::UnknownOperator

# You can use try/throw for controlled error handling within rules
rule = JSON.parse(%(
  {"try": [{"throw": "Something went wrong"}, {"cat": ["Error: ", {"var": "type"}]}]}
))
ShinyJsonLogic.apply(rule, JSON.parse("null"))
# => "Error: Something went wrong"
```

Exception classes:
- `ShinyJsonLogic::Errors::UnknownOperator` — unknown operator in rule
- `ShinyJsonLogic::Errors::InvalidArguments` — invalid arguments to operator
- `ShinyJsonLogic::Errors::NotANumber` — NaN result in numeric operation

Or rescue `ShinyJsonLogic::Errors::Base` to handle all library errors in one sweep.

---

## Compatibility

Tested against the [official JSON Logic test suite](https://github.com/json-logic/.github/tree/main/tests) (613 tests).

| Passed | Total |
|--------|-------|
| **613** | **613** |

---

## Development

```bash
shards install
crystal spec
```

To run the official test suite against live test data:

```bash
bin/test.sh
```

Requires `curl` and `crystal`. Fetches the official tests at runtime from `github.com/json-logic/.github`.

---

## Contributing

Contributions are welcome — especially:

- spec alignment improvements
- missing operators
- edge-case tests
- performance improvements

Please include tests with any change.

See [CONTRIBUTING.md](CONTRIBUTING.md) for details.

Repository: https://github.com/luismoyano/shiny_json_logic_crystal

---

## Related projects

- [shiny_json_logic (Ruby)](https://rubygems.org/gems/shiny_json_logic) — 613/613 official tests, the most compliant Ruby implementation
- [shiny/json-logic-php](https://packagist.org/packages/shiny/json-logic-php) — 613/613 official tests, the most compliant PHP implementation
- [shinyjsonlogic.com](https://shinyjsonlogic.com) — JSON Logic playground, docs, and specification reference

---

## License

MIT License.

Use it. Fork it. Ship it. (:

---

> Shine bright like a 🔮
