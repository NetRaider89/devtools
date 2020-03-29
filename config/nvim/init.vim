call plug#begin('$XDG_CONFIG_HOME/nvim/plugins')
Plug 'ajmwagar/vim-deus'
call plug#end()

" <g:python3_host_prog>
" <g:node_host_prog>

set background=dark " dark background colorscheme
colorscheme despacio

syntax enable       " enable syntax highlighting
set number          " show line numbers
set colorcolumn=79  " lines longer than 79 columns will be broken
set scrolloff=3

" uses hard tab indentation
set autoindent      " align the new line indent with the previous line
set tabstop=4       " a hard TAB displays as 4 columns
set shiftwidth=4    " operation >> indents 4 columns; << unindents 4 columns
set shiftround      " round indent to multiple of 'shiftwidth'
set noexpandtab     " don't insert spaces when hitting TABs

" define chars for indentation guides
set listchars=tab:│\ ,trail:·,extends:→
set list

set splitright      " vsplit creates a new vertical split to the right
set splitbelow      " split creates a new horizontal split below
set mouse=vn        " enables mouse interaction only in visual and normal modes
set showcmd         " show partial command in the lower right portion of the screen

inoremap jk <esc>

" disable highlight search
set nohls

" python settings
" disables tabstop=8 and expandtab settings in $VIMRUNTIME/ftplugin/python.vim
let g:python_recommended_style = 0
