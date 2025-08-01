## 0.0.7 (unreleased)

### Added

### Changed

- Switch to standalone library `print-table`.
- Split test package & use `expect_test_helpers_base`.

### Deprecated

### Fixed

### Removed

## 0.0.6 (2024-07-26)

### Added

- Added dependabot config for automatically upgrading action files.

### Changed

- Upgrade `ppxlib` to `0.33` - activate unused items warnings.
- Upgrade `ocaml` to `5.2`.
- Upgrade `dune` to `3.16`.
- Upgrade base & co to `0.17`.

## 0.0.5 (2024-03-13)

### Changed

- Uses `expect-test-helpers` (reduce core dependencies). This results in using `sexp_pretty` in tests, which improves sexp layout.
- Run `ppx_js_style` as a linter & make it a `dev` dependency.
- Upgrade GitHub workflows `actions/checkout` to v4.
- In CI, specify build target `@all`, and add `@lint`.
- List ppxs instead of `ppx_jane`.

### Removed

- Removed `stdio`. Now uses `expect-test-helpers` in test.

## 0.0.4 (2024-02-14)

### Changed

- Upgrade dune to `3.14`.
- Build the doc with sherlodoc available to enable the doc search bar.

## 0.0.3 (2024-02-09)

### Changed

- Internal changes related to the release process.
- Upgrade dune.

## 0.0.2 (2024-01-18)

### Changed

- Internal changes related to build and release process.
- Generate opam file from `dune-project`.

## 0.0.1 (2023-11-01)

### Added

- Added Poomsae 1, 2, 3, Drafted 4-7
- Stating and checking some facts about Poomsae 1-2
