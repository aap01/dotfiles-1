set nocompatible
filetype off

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" ################
" # Settings #####
" ################

Bundle 'gmarik/vundle'
Bundle 'altercation/vim-colors-solarized'
Bundle 'kchmck/vim-coffee-script'
Bundle 'scrooloose/nerdtree'
Bundle 'scrooloose/syntastic'
Bundle 'kien/ctrlp.vim'
Bundle 'bling/vim-airline'
Bundle 'tpope/vim-fugitive'
Bundle 'scrooloose/nerdcommenter'
Bundle 'elzr/vim-json'
Bundle 'Raimondi/delimitMate'
Bundle 'garbas/vim-snipmate'
Bundle 'honza/vim-snippets'
Bundle 'marcweber/vim-addon-mw-utils'
Bundle 'tomtom/tlib_vim'
Bundle 'Yggdroot/indentLine'
Bundle 'airblade/vim-gitgutter'

filetype plugin indent on
syntax enable

" ################
" # Theme ########
" ################

colorscheme solarized
let g:indentLine_color_term = 235
let g:indentLine_char = '·'
highlight clear SignColumn

" ################
" # Settings #####
" ################

set expandtab
set smarttab                " Use tabs for indentation and spaces for alignment
set number
set tabstop=4               " a tab is four spaces
set shiftwidth=4            " number of spaces to use for autoindenting
set softtabstop=4           " when hitting <BS>, pretend like a tab is removed, even if spaces
set visualbell              " don't beep
set noerrorbells            " don't beep
set exrc                    " enable per-directory .vimrc files
set secure                  " disable unsafe commands in local .vimrc files
set mouse=a
set laststatus=2            " Always show the status line
set backspace=indent,eol,start
set clipboard=unnamed       " Use system clipboard

" Airline
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1

" Cut trailing whitespaces
autocmd BufWritePre * :%s/\s\+$//e

" ################
" # Shortcuts ####
" ################

" With a map leader it's possible to do extra key combinations
let mapleader = ","
let g:mapleader = ","

" easier window navigation
nmap <C-h> <C-w>h
nmap <C-j> <C-w>j
nmap <C-k> <C-w>k
nmap <C-l> <C-w>l

" Buffer
nmap <C-n> :bp<cr>
nmap <C-m> :bn<cr>
nmap <C-z> :bd<cr>

" Fast saves
nmap <leader>w :w!<cr>

imap jj <Esc>            " Easy escaping to normal model

" Open splits
nmap vs :vsplit<cr>
nmap sp :split<cr>

" Resize vsplit
nmap <C-v> :vertical resize +5<cr>
nmap 25 :vertical resize 40<cr>
nmap 50 <c-w>=
nmap 75 :vertical resize 120<cr>

nmap <C-b> :NERDTreeToggle<cr>

" Really jump to new line
nnoremap j gj
nnoremap k gk
