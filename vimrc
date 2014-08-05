" Enable syntax highlighting
syntax on

" Better command-line completion
set wildmenu

" Use case insensitive search, except when using capital letters
set ignorecase
set smartcase

" When opening a new line and no filetype-specific indenting is enabled, keep
" the same indent as the line you're currently on. Useful for READMEs, etc.
set autoindent

" Instead of failing a command because of unsaved changes, instead raise a
" dialogue asking if you wish to save changed files.
set confirm

" Enable use of the mouse for all modes
set mouse=a

" Display line numbers on the left
set number

" Filetype Indentation Mode
filetype plugin indent on

" Indentation settings for using 2 spaces instead of tabs.
" Do not change 'tabstop' from its default value of 8 with this setup.
set shiftwidth=2
set softtabstop=2
set expandtab

" copy to and from system clipboard
set clipboard=unnamed,unnamedplus

" set spell checking for certain filetypes
autocmd BufRead,BufNewFile *.md setlocal spell
autocmd FileType gitcommit setlocal spell

" enable pathogen
execute pathogen#infect()

" add custom filetypes
au BufNewFile,BufRead *.launch set filetype=xml

" toggle NERDTree with Ctrl+n
map <C-n> :NERDTreeToggle<CR>

" toogle TagBar with <F8>
nmap <F8> :TagbarToggle<CR> 

" show whitespace in cpph files
"set list listchars=tab:>-,trail:·,extends:>
