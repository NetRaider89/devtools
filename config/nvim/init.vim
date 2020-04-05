call plug#begin('$XDG_CONFIG_HOME/nvim/plugins')
Plug 'ajmwagar/vim-deus'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
call plug#end()

" <g:python3_host_prog>
" <g:node_host_prog>

set background=dark
colorscheme despacio

syntax enable
set number
set colorcolumn=79
set scrolloff=3

" prefer hard tab indentation
set autoindent
set tabstop=4
set shiftwidth=4
set shiftround
set noexpandtab

" define chars for indentation guides
set listchars=tab:│\ ,trail:·,extends:→
set list

set splitright
set splitbelow
set mouse=vn
set showcmd

inoremap jk <esc>
inoremap <silent><expr> <C-x><C-o> coc#refresh()

" disable highlight search
set nohls

" python settings
" disables tabstop=8 and expandtab settings in $VIMRUNTIME/ftplugin/python.vim
let g:python_recommended_style = 0
