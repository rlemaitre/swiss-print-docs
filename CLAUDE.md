# CLAUDE.md

Markdown to PDF kit in the rlemaitre.com Swiss print design. Usage and layout: `README.md`.

## Commands

- `mise run test`: build `examples/sample.md` from another folder; fails on any WeasyPrint warning
- `mise run lint`: shellcheck and shfmt
- `mise run sample`: write `out/sample.pdf`

## Rules

- Tools are repo-only (`mise.toml`): never install pandoc or weasyprint globally, and call them through
  `mise exec --cd "$KIT_DIR"`. `swiss-doc` must keep working from any folder and through a symlink: resolve paths to
  absolute before running the tools, and keep the smoke test running from outside the repo.
- The design comes from `rlemaitre-github-io` (`src/styles/tokens.css`, `prose.css`, `print.css`) and the
  `slidev-templates` theme (code colors). Change the site first, then port the change to `pdf/swiss-print.css`.
- Check PDF changes visually: render pages to PNG (PDFKit through `swift`, or `sips` for page 1) and look at them.
