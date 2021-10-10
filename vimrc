call plug#begin('~/.vim/plugged')

Plug 'LnL7/vim-nix'
Plug 'vmchale/dhall-vim'
Plug 'neovimhaskell/haskell-vim'

call plug#end()

filetype plugin indent on

set backupdir=~/.cache/vim/backup
set undodir=~/.cache/vim/undo


set encoding=utf-8

set laststatus=2

" line numbers
set number
set ruler
set showmode

" syntax
syntax on
:colors torte

set clipboard=

set shiftwidth=4
set tabstop=4

set list
set listchars=tab:\|\ ,trail:·

set smarttab
set showmatch
set noerrorbells
set backspace=indent,eol,start

set scrolloff=2

set wildignore=*.o,*.class,*.pdf

" remove whitespace on save
autocmd BufWritePre *.* :%s/\s\+$//e
match ErrorMsg '\%>80v.\+'

:imap jj <Esc>
:nmap <C-K> <C-U>
:nmap <C-J> <C-D>
