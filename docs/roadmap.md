# Roadmap

Build dict.nvim: look a word up in a local DICT server and read the result in
Neovim. Each step ends with the plugin in a working state. How a step is run
is in the `step-start` and `step-review` skills under `.claude/skills/`.

## Design decisions

These were settled before the roadmap was written. A step that needs to depart
from one of them should say so and update this section.

- **The server is a local `dictd`** on `127.0.0.1:2628`, serving `wn`
  (WordNet) and `wiktionary` (English Wiktionary). It is set up outside this
  plugin, in the owner's dotfiles (hypatia-tile/dotfiles-mac#286).
- **The plugin runs the `dict` CLI** with `vim.system`, asynchronously. All
  of that sits behind one internal interface, `backend.define(word, dbs, cb)`
  (and a matching call for suggestions), so the transport can later become a
  direct TCP client over `vim.uv` without the UI changing.
- **`dict` takes one `-d` per call**: the last `-d` wins. Querying several
  databases is one call per database.
- **Databases are an option**, `databases = { "wn", "wiktionary" }`, in that
  order.
- **One window, every database stacked** in the order of `databases`. Each
  database's result starts with a header line naming it.
- **The result opens in a float**, which can be turned into a normal split.
  The buffer is a scratch buffer with `filetype=dict`.
- **No match shows suggestions** from `dict -m -s lev` in the same window,
  and choosing one looks it up. With no suggestions either, a one-line
  `vim.notify`.
- **No global keymaps.** The plugin exposes `require("dict").lookup()`, which
  uses the visual selection in visual mode and the word under the cursor
  otherwise, and `:Dict [word]`, which prompts when the word is missing. The
  user's config maps the keys.
- **Keys inside the result window** are buffer-local and the plugin's:

  | Key | Action |
  |---|---|
  | `q` | close |
  | `]]` / `[[` | next / previous database section |
  | `<CR>` | look up the word under the cursor (a cross-reference, a synonym, a suggestion) |
  | `<C-s>` / `<C-v>` | turn the float into a horizontal / vertical split |

- **Tests** use plenary.nvim's busted runner in headless Neovim (`make test`).
  A test that needs the server is skipped, not failed, when the server is not
  running; everything that can be tested on captured text is.
- **Neovim 0.10 or later** (`vim.system`).

### What the server sends

Facts measured on the owner's machine, to save rediscovering them:

- `dict -d wn hello` prints `1 definition found`, a blank line, then
  `From WordNet (r) 2.1 (2005) [wn]:` and the definition. Every definition
  starts with such a `From <name> [<db>]:` line.
- WordNet joins the words of a phrase with underscores: `carry_out`, not
  `carry out`. Wiktionary uses spaces.
- Exit status, measured with dict 1.13.3: `0` when found, `20` when nothing
  matched (for `-m` too), `39` for an unknown database, `41` when no server
  answers. `dict(1)` has the full list under EXIT STATUS.
- Wiktionary's text keeps its wiki templates, which nest and can span a
  wrapped line: `{{ng|A greeting used when answering the telephone.}}`,
  `{{ux|en|Hello? How may I help you?}}`, `{{lb|en|colloquial}}`,
  `{{plural of|en|mouse}}`. It also lists every language that has the
  headword (`helo` has Esperanto, Finnish, Hawaiian …), at an indent of four
  spaces, and the English section is the one to keep.
- `def` in the dotfiles (`config/zsh/modules/dict.zsh`) cleans Wiktionary's
  text in awk. It is one way to do it, not the way this plugin must.

Capture real output to test against with, for example:

```sh
dict -h 127.0.0.1 -d wiktionary hello > tests/fixtures/wiktionary-hello.txt
```

## Steps

- [ ] **Step 1 — `:Dict` prints raw output.** `lua/dict/init.lua` with
  `setup(opts)` and the `databases` and `host` options;
  `lua/dict/backend.lua` with `define(word, dbs, cb)` running `dict` once per
  database, in order, and passing the combined text (or an error) to `cb`;
  `:Dict word` prints the result with `vim.notify`. Tests: `setup` merges
  options; `define` calls `cb` once with every database's text, in order (a
  test against the server, skipped without it). This is the step after which
  hypatia-tile/dotfiles-mac#287 can load the plugin.
- [ ] **Step 2 — Parse into sections.** `lua/dict/parse.lua` turns `dict`'s
  output into a list of `{ db, name, lines }`, one per definition, dropping
  the `N definitions found` lines. Tests on captured fixtures: WordNet, a
  Wiktionary entry with several definitions, an empty result.
- [ ] **Step 3 — The float.** Show the sections in a centred float, each
  under a header line with its database's name, in a scratch buffer with
  `filetype=dict`; `q` closes it. Tests: the float opens, holds the expected
  lines, has the filetype, and closes on `q`.
- [ ] **Step 4 — Move between sections.** `]]` and `[[` move the cursor to
  the next and previous header line, and stop at the ends. Tests on a buffer
  with three sections.
- [ ] **Step 5 — Promote to a split.** `<C-s>` and `<C-v>` close the float
  and show the same buffer in a horizontal or vertical split, with the
  buffer-local keys still working. Tests: the window is no longer floating,
  the buffer is the same.
- [ ] **Step 6 — Look up from the buffer.** `require("dict").lookup()`: the
  word under the cursor in normal mode, the selection in visual mode, with
  WordNet's phrases joined by `_`. `<CR>` in the result window looks up the
  word under the cursor there. `:Dict` with no argument prompts. Tests: the
  word taken in each mode, the WordNet spelling of a phrase.
- [ ] **Step 7 — Suggestions on no match.** When no database has an entry,
  the window lists `dict -m -s lev` suggestions per database, and `<CR>` on
  one looks it up. With no suggestions either, `vim.notify` says so and no
  window opens. Tests on captured `-m` output, and the no-suggestion case.
- [ ] **Step 8 — Clean Wiktionary's text.** Keep only the English section,
  and turn the common templates into their text (`ng`, `n-g`, `ux`, `lb`,
  `gloss`, `q`, `syn`, `ant`, `… of`), dropping the rest. Tests on captured
  fixtures, including a template that spans a wrapped line and one nested in
  another.
- [ ] **Step 9 — Errors and documentation.** A `dict` that is missing, or a
  server that is down, is one clear `vim.notify` at error level, not a stack
  trace. `doc/dict.txt` documents the options, `lookup()`, `:Dict` and the
  window keys, and the README gains a configuration example for lazy.nvim.
