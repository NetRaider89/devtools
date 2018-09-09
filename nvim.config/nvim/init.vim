call plug#begin('$XDG_CONFIG_HOME/nvim/plugins')
Plug 'ajmwagar/vim-deus'
Plug 'srstevenson/vim-picker'
call plug#end()


set number          " show line numbers
syntax enable       " enable syntax highlighting
set background=dark " dark background colorscheme
colorscheme deus    " set colorscheme
set colorcolumn=79  " lines longer than 79 columns will be broken
set shiftwidth=4    " operation >> indents 4 columns; << unindents 4 columns
set tabstop=4       " a hard TAB displays as 4 columns
set expandtab       " insert spaces when hitting TABs
set softtabstop=4   " insert/delete 4 spaces when hitting a TAB/BACKSPACE
set shiftround      " round indent to multiple of 'shiftwidth'
set autoindent      " align the new line indent with the previous line
set splitright      " vsplit creates a new vertical split to the right
set splitbelow      " split creates a new horizontal split below
set mouse=vn        " enables mouse interaction only in visual and normal modes
set showcmd         " show partial command in the lower right portion of the screen

inoremap jk <esc>

