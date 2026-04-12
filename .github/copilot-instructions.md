---
description: "Project-specific Copilot guidance for nix-flake-config. Use this file to bootstrap agent behavior in this repo and to locate the architecture, data model, test commands, and implementation boundaries."
---

# nix-flake-config Copilot Instructions

This repository is a layered Nix flake config with a strict multi-stage architecture.
Use this file as the first source of truth for how to work in the repo, and link rather than duplicate the project documentation.

## Start here

1. Read `docs/README.md` first.
2. Then read the docs that define architecture and data flow:
   - `docs/architecture.md`
   - `docs/core-concepts.md`
   - `docs/data-model.md`
   - `docs/resolution-flow.md`
   - `docs/module-boundaries.md`
   - `docs/directory-layout.md`
   - `docs/option-schema.md`
3. Consult `AGENTS.md` for long-term agent and implementation constraints.

## Key boundaries

- `profile.users`, `profile.hosts`, and `profile.relations` are declaration sources.
- `Relation` is the only instance creation path.
- `normalize`, `validate`, `instantiate`, `context`, `projection`, and `assembly` are distinct stages.
- `Projector` must consume unified intermediate interfaces like `current` and `projectionInputs`, not raw source declarations.
- `Assembly` must merge and attach results, not reinterpret semantics or perform normalization/validation.
- Do not rely on private/internal fields like `_internal`, `_cache`, `_derived`, or `_tmp` for normal flow.

## Implementation workflow

When making changes, follow the stage order in `AGENTS.md`:
1. schema / source
2. normalize
3. validate
4. instantiate
5. context
6. projection
7. assembly

For any substantive change, identify which stage(s) it touches and update tests accordingly.

## Tests and validation

- Use `nix flake check` to run the repository checks.
- `flake.nix` exports `checks` via `tests/default.nix`.
- Key test entrypoints:
  - `tests/default.nix`
  - `tests/normalize.nix`
  - `tests/instantiate.nix`
  - `tests/context.nix`
  - `tests/projection.nix`
  - `tests/assembly.nix`

When changes affect a phase, add or update tests in the matching `tests/` file.

## Project structure

- `users/`, `hosts/`, `relations/` are declaration inputs.
- `modules/schema/`, `modules/normalize/`, `modules/validate/`, `modules/instantiate/`, `modules/context/`, `modules/projection/`, and `modules/assembly/` implement the resolution pipeline.
- `modules/entrypoints/` wires the flake outputs and exports `profile`, `pipeline`, and backend configurations.

## When to ask for clarification

- If the requested change touches backend behavior or option semantics, confirm whether it should be implemented in `projection` or `assembly`.
- If a new field is introduced, confirm its owner (`User`, `Host`, or `Relation`) and whether it is source or derived.
- If a proposed fix would violate the `User` / `Host` / `Relation` boundary rules, stop and review `AGENTS.md` and `docs/data-model.md` first.

## Example prompts

- "Add support for a new `profile.relations[].capabilities` field and wire it through validate, instantiate, and projection."
- "Fix the darwin backend so unsupported packages are preserved in `current` and emitted as warnings."
- "Add a test that verifies `home-manager` backend relations do not require `home.homeDirectory` in `users` source."

## Notes

- Prefer linking to documentation rather than embedding architecture rationale.
- Preserve existing repo conventions and avoid introducing broad helper files like `misc.nix`.
