# Contributing to shiny_json_logic

Thanks for contributing to Shiny!!

## Quick start

```bash
shards install
crystal spec
```

To run the full official test suite:

```bash
bin/test.sh
```

## What we're looking for

- Spec alignment improvements
- Missing operators
- Edge-case tests
- Performance improvements (with tests)

## Bug reports

Please include:

- The JSON Logic rule (as JSON)
- The data input
- Expected output
- Actual output
- Crystal version (`crystal --version`) and shard version

A minimal reproduction is ideal.

## Adding an operator

1. Implement the operator in `src/shiny_json_logic/operations/` — one file per operator.
2. Register it at the bottom of the file: `ShinyJsonLogic::Engine.register("op") { |a, s| ... }`.
3. Add the `require` to `src/shiny_json_logic.cr`.
4. Add focused specs under `spec/`.
5. Keep behavior aligned with JSON Logic semantics and consistent with the Ruby and PHP ports.
6. Avoid adding runtime dependencies.

## Code style

Keep changes small and explicit. Prefer tests that document behavior.
