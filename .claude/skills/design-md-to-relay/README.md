# design-md-to-relay

Generate Relay/Zero reference designs from JD design wiki markdown.

This skill supports many components, not only Tabbar. It uses a generic pipeline:

```text
clarify scope
→ sync foundation (auto-pull upstream)
→ resolve target design.md
→ read wiki bundle
→ read foundation tokens and visual rules
→ build normalized spec JSON
→ optionally probe ground truth for missing fields
→ plan Relay node tree
→ fetch and normalize assets
→ write in small batches
→ verify with metadata and screenshot
```

## Key Design Decisions

### Runtime Wiki Reads

Component specs stay in the main wiki repository. **Do not copy** every component `design.md` into this skill.

The skill `references/` folder contains only workflow docs, normalized spec schema, adapter notes, and implementation guidance. At runtime, the skill resolves the target component and reads source wiki files directly:

```text
jd-design-system-md-v16/**/<slug>/design.md
jd-design-system-md-v16/**/<slug>/spec.md
jd-design-system-md-v16/**/<slug>/variants.md
jd-design-system-md-v16/**/<slug>/behaviors.md
jd-design-system-md-v16/**/<slug>/ai-schema.yaml
```

This avoids version drift between the skill and the wiki.

### Foundation Auto-Pull

The skill runs `git pull --ff-only origin main` at Step 1 to sync foundation from upstream. Commit SHA is recorded in the output report under `foundationVersion.commit` so each run is traceable to a specific foundation snapshot.

Failure handling:

| State | Action |
|---|---|
| Success / up-to-date | proceed with upstream HEAD |
| Diverged (local commits ahead) | use local; warn with SHA + reason |
| Network failure | use local cache; warn with SHA + age |
| Repo missing | fail; prompt clone |
| `--no-pull` flag | skip pull entirely |
| `--foundation-from <path>` flag | bypass repo, use specified path |

See [`references/foundation-token-table.md`](references/foundation-token-table.md).

### Scope First

The skill clarifies the requested output shape **before** drawing. A user asking for "一个底导设计稿" may only want one bottom navigation in a phone page, not a full state matrix or component spec board.

If scope is ambiguous, the skill asks one concise question and waits.

### Wiki First, Ground Truth Second

Ground truth Relay nodes are useful for missing fields and diff reports, but they must **not** override explicit wiki/foundation fields silently. The skill does not clone original designs unless the user explicitly asks.

Source precedence:

```text
user scope
> ai-schema.yaml / spec.md structured fields
> design.md explicit fields
> foundation tokens and visual rules
> component adapter defaults
> ground truth for missing fields only
```

### Normalized Spec Before Drawing

Markdown is for humans. Relay scripts need structured instructions. The skill first converts the wiki into a normalized JSON execution contract, then writes the design from that contract.

Benefits:

- separates understanding from execution
- enables verification assertions
- supports retry / resume
- traceable provenance per field

### Generic Core, Component Adapters

The core workflow is generic. Component-specific details live in adapters:

- `references/adapters/tabbar.md`
- `references/adapters/button.md`
- `references/adapters/toast.md`
- `references/adapters/navbar.md`

If no adapter exists, the skill uses the generic normalized spec flow and asks for scope if anatomy is unclear.

## Current Status: v0.1 骨架

Workflow + contracts are in place. Executable scripts pending.

v0.2 implementation starts after upstream [issue #60](https://github.com/ShuaiMXu/jd-design-wiki-proposal/issues/60) P0 dependencies merge:

| Gap | Upstream issue section | Affects |
|---|---|---|
| design.md 02.4 表选中态尺寸不闭合 | [#60 Gap 1](https://github.com/ShuaiMXu/jd-design-wiki-proposal/issues/60) | Step 3 read bundle |
| Relay 原版组件未 anchored 为 ground truth | [#60 Gap 2](https://github.com/ShuaiMXu/jd-design-wiki-proposal/issues/60) | Step 6 probe ground truth |
| Auto Layout 模式 wiki 未明文 | [#60 Gap 3](https://github.com/ShuaiMXu/jd-design-wiki-proposal/issues/60) | Step 7 plan node tree |
| `_assets-cdn.md` 只登记 PNG | [#60 Gap 4](https://github.com/ShuaiMXu/jd-design-wiki-proposal/issues/60) | Step 8 fetch assets |

## Roadmap

| Version | Content | Dependency |
|---|---|---|
| **v0.1**(本骨架) | SKILL.md + 4 references + Tabbar adapter | none |
| v0.2 | Step 0-5 implementation (clarify, sync, resolve, read bundle, foundation, normalized spec) | issue #60 Gap 1 + 2 |
| v0.3 | Step 6-8 (ground truth probe, plan tree, fetch assets) | issue #60 Gap 3 |
| v0.4 | Step 9-10 (execute + verify with tolerances) | issue #60 Gap 4 |
| v0.5 | **Tabbar single-instance generation on 375x812 page · validated end-to-end** | all above |
| v0.6 | Button variant generation · second component validates generic core | v0.5 |
| v0.7 | Toast floating component generation · third validation | v0.6 |
| v1.0 | page-doc bundle level (L2/L3/L4) | v0.7 |

Each implementation hardens the normalized spec schema and verification assertions.

## Skill Matrix Position

```text
                          Relay
                          ↑    ↓
  relay-to-design-md   ───┘    └───  design-md-to-relay (this skill)
                                 ↓
                            design.md (bundle)
                                 ↓
                                 ├── design-md-to-portal
                                 ├── design-md-to-spec-page
                                 └── design-review
```

V16 三面四 skill 闭环完成(原 4 个 + 本 skill = 5 个)。

## Design Provenance

This v0.1 骨架 incorporates two sources:

1. **R3 Tabbar 走查实录**(2026-05-20):exposed 4 wiki gaps + 4 implementation pitfalls. Distilled into [`references/adapters/tabbar.md`](references/adapters/tabbar.md).
2. **User-provided v0.2 draft**:contributed the Prime Directive, Source Precedence, Normalized Spec JSON layer, Adapter pattern, relaxed tolerances, and "don't clone" guardrails. This skill version learned from that draft (see commit `feat(skill): 全套合并 user v0.2 草稿 + 保留 Foundation auto-pull / issue #60 协同`).

Skill and upstream issue #60 are mutual products:

- **skill** = the "correct way" codified after wiki gaps are fixed
- **issue** = wiki gaps surfaced during skill design

upstream issue: https://github.com/ShuaiMXu/jd-design-wiki-proposal/issues/60

## Contributing (v0.2 onward)

1. Wait for upstream issue #60 P0 PRs to merge
2. Fork this repository, branch off `feat/skill-design-md-to-relay`
3. Implement Steps per the SKILL.md workflow
4. Validate: tabbar → button → toast → navbar
5. PR to fork → review → upstream
