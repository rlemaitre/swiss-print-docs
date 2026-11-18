# swiss-print-docs

Markdown to PDF in the [rlemaitre.com](https://rlemaitre.com) Swiss print design.

```sh
bin/swiss-doc notes.md            # notes.pdf next to notes.md
bin/swiss-doc -o out/ *.md        # into out/
```

## Requirements

Only [mise](https://mise.jdx.dev). `pandoc` and `weasyprint` are pinned in this repo's `mise.toml` and installed for this
repo only, never globally. WeasyPrint comes from conda-forge, which ships pango and the other native libraries it needs.

## Setup (once per Mac)

1. In the repo: `mise trust && mise install`. Without the trust, mise refuses the config; without the install, the
   tools are missing.
2. To type `swiss-doc` from anywhere: `ln -s "$PWD/bin/swiss-doc" ~/.local/bin/swiss-doc` (`~/.local/bin` must be on
   your `PATH`).

## Calling it from another folder

`swiss-doc` works from any folder, directly or through the symlink:

- it finds the kit folder from its own path (`readlink -f`), so a symlink is followed;
- it runs pandoc and WeasyPrint with `mise exec --cd <kit>`, so the kit's pinned versions are used, whatever the
  current folder's own `mise.toml` says;
- it turns the input and `-o` paths into absolute paths first, so relative paths resolve from where you called it.

`mise run test` checks this: it builds the sample from a temporary folder with a relative `-o`.

## Front matter

All fields are optional.

```yaml
---
title: Typed configuration *without* the ceremony   # *emphasis* turns red
subtitle: One line under the title
kicker: Article · Scala 3                           # red label above the title
author: Raphaël Lemaitre                            # or a list
date: 2026-10-17
lang: fr                                            # hyphenation and quotes
author-label: Auteur                                # labels of the metadata column
date-label: Date
---
```

## How it works

pandoc turns the Markdown into HTML with `pdf/template.html`, then WeasyPrint prints it with `pdf/swiss-print.css`:
the site's tokens and `prose.css` at print sizes, its print palette (white paper, ink `#0b0b0b`, red `#d01414`), and
the swiss-print Slidev theme's code colors. Pages are A4 with a running title and an `01 / 02` page count. Fonts are
embedded.

## Changing the design

1. Edit `pdf/swiss-print.css` (tokens at the top).
2. `mise run test` builds `examples/sample.md` and fails on any WeasyPrint warning.
3. `mise run sample` writes `out/sample.pdf` to look at.

## Known limits

- WeasyPrint crashes on `::marker { content }`, so the dash bullets use `list-style-type`.
- Long code lines wrap inside the block, mid-token if needed.
- Fonts are TTF, not the site's WOFF2: conda-forge's WeasyPrint lacks the Brotli module that WOFF2 needs.

## Licenses

Fonts in `fonts/` are under the SIL Open Font License 1.1 (`fonts/LICENSE-*`): Fontsource's latin subsets, converted
from WOFF2 to TTF.
