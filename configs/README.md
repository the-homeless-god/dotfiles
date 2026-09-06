# Configs

## Vim

1. After open use `:PlugInstall`
2. After plugins installation use `:CocInstall coc-tsserver coc-eslint coc-json coc-prettier coc-css coc-html coc-snippets`

### Colour scheme

`.vim/colors/digitable.vim` is the scheme `.vimrc` enables. It is installed by
`scripts/install-tools.sh` together with `.vimrc`; nothing has to be downloaded.
To try it without installing anything:

```sh
vim -Nu NONE -c 'set rtp+=configs/.vim' -c 'colorscheme digitable' README.md
```

Colours and role mapping both come from the Digitable Courses portal — the file
header names the exact source of every value. Do not hand-edit the hex numbers:
change the palette table at the top of the file instead, and re-measure.
