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

" option for MatchTagAlways
let g:mta_use_matchparen_group = 1

" mini-bufexpl customization
" set minibufexp to split vertically and to the right
let g:miniBufExplBRSplit = 1
let g:miniBufExplVSplit = 1

" set max column size
let g:miniBufExplMaxSize = 30

" use Ctrl+Page Up/Down to change buffers
noremap <C-PageDown> :MBEbn<CR>
noremap <C-PageUp> :MBEbp<CR>

" same as above but in MRU fashion
noremap <C-TAB> :MBEbb<CR>
noremap <C-S-TAB> :MBEbf<CR>

" should buffer be cycled arround if hits the begining or the endi
let g:miniBufExplCycleArround = 1

" toogle minibufexpl with <F9>
map <F9> :MBEToggle<CR>

" vim-airline customization
" set vim to 256 colors to work with terminals
set t_Co=256

" don't show vim's mode, use airline's instead
set noshowmode

" make airline visible without split
set laststatus=2

" remove delay detween insert and normal mode
set ttimeoutlen=50

" change default colors for airline
let g:airline_theme = 'kolor'

" enable powerline symbols, needs powerline fonts installed
let g:airline_powerline_fonts = 1

" change default font for gvim to enable powerline symbols
if has('gui_running')
set guifont=DejaVu\ Sans\ Mono\ for\ Powerline\ 10
endif

" change default indent character for indentLine
let g:indentLine_char = '┊'

" disable indentLine plugin on startup
let g:indentLine_enabled = 0

" toggle indentLine with <F7>
nmap <F7> :IndentLinesToggle<CR>
