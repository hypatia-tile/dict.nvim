# dict.nvim

Look words up in a [DICT](https://www.rfc-editor.org/rfc/rfc2229) server
(such as `dictd`) from Neovim, and read the result in a floating window.

It is written for an English–English dictionary served locally — WordNet and
English Wiktionary — but works with any database a DICT server offers.

**Status:** in development. The plan, and the design it follows, is in
[`docs/roadmap.md`](docs/roadmap.md).

## Requirements

- Neovim 0.10 or later.
- The `dict` client on `PATH`, and a DICT server it can reach (by default
  `127.0.0.1`).

## Development

```sh
make test
```

The tests run headless with plenary.nvim's busted runner. The first run
clones plenary.nvim into `.tests/`.

## Licence

MIT. See [`LICENSE`](LICENSE).
