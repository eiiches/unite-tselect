# unite-tselect

## Introduction

`unite-tselect` is a [unite.vim](https://github.com/Shougo/unite.vim) source plugin
for selecting tags, providing a similar functionality as :tselect command.


## Usage

To search tags for `<keyword>`, execute

    :Unite tselect:<keyword>

If you want to replace `g<C-]>` and `g]`, copy the following lines into your vimrc.

    nnoremap g<C-]> :<C-u>Unite -immediately tselect:<C-r>=expand('<cword>')<CR><CR>
    nnoremap g] :<C-u>Unite tselect:<C-r>=expand('<cword>')<CR><CR>

