"****************************  GENERAL SETTINGS  *******************************
" PROGRAM SETTINGS
" Instead of failing a command because of unsaved changes, instead raise
" dialogue asking if you wish to save changed files.
set confirm

" When you type the first tab, it will complete as much as possible, the second
" tab hit will provide a list, the third and subsequent tabs will cycle through
" completion options so you can complete the file without further keys
set wildmode=longest,list,full
set wildmenu " completion with menu

set fileformat=unix " file mode is unix
set fileformats=unix,dos,mac " detects unix, dos, mac file formats in that order
set viminfo='20,\"500 " remember copy registers after quitting in the .viminfo
" file -- 20 jump links, regs up to 500 lines'
"
set hidden " allows making buffers hidden even with unsaved changes
set history=1000 " remember more commands and search history
set undolevels=1000 " use many levels of undo
set autoread " auto read when a file is changed from the outside
set mouse=a " enables the mouse in all modes
set mousemodel=popup_setpos " Right-click on selection should bring up a menu

" Unicode support (taken from http://vim.wikia.com/wiki/Working_with_Unicode)
if has("multi_byte")
if &termencoding == ""
let &termencoding = &encoding
endif
set encoding=utf-8
setglobal fileencoding=utf-8
set fileencodings=ucs-bom,utf-8,latin1
endif

" The "longest" option makes completion insert the longest prefix of all
" the possible matches; see :h completeopt
set completeopt=menu,menuone,longest
set switchbuf=useopen,usetab

" set vim to 256 colors to work with terminals
set t_Co=256

" Filetype Indentation Mode
filetype plugin indent on

" Enable syntax highlighting
syntax on
syntax enable

" enable pathogen
execute pathogen#infect()

" DISPLAY SETTINGS
set background=dark " enable for dark terminals
set scrolloff=2 " 2 lines above/below cursor when scrollin
set showmatch " show matching bracket (briefly jump)
set matchtime=2 " reduces matching paren blink time from the 5[00]ms def
set showcmd " show typed command in status bar
set title " show file in titlebar
set number " Display line numbers on the left
set ttimeoutlen=50 " remove delay detween insert and normal mode
" This changes the default display of tab and CR chars in list mode
set listchars=tab:▸\ ,eol:¬


" EDITOR SETTINGS
set ignorecase " case insensitive searching
set smartcase " but become case sensitive if you type uppercase characters
" this can cause problems with other filetypes
" see comment on this SO question http://stackoverflow.com/questions/234564/tab-key-4-spaces-and-auto-indent-after-curly-braces-in-vim/234578#234578
set smartindent " smart auto indenting
set autoindent " on new lines, match indent of previous line
set copyindent " copy the previous indentation on autoindenting
"set cindent " smart indenting for c-like code
"set cino=b1,g0,N-s,t0,(0,W4 " see :h cinoptions-values
set smarttab " smart tab handling for indenting
set magic " change the way backslashes are used in search patterns
set bs=indent,eol,start " Allow backspacing over everything in insert mode
"set nobackup " no backup~ files.
set tabstop=2 " number of spaces a tab counts for
set shiftwidth=2 " spaces for autoindents
set softtabstop=2
set shiftround " makes indenting a multiple of shiftwidth
set expandtab " turn a tab into spaces
set laststatus=2 " the statusline is now always shown
set noshowmode " don't show the mode ("-- INSERT --") at the bottom

set nowrap " Don't automatically wrap on load
set fo-=t " Don't automatically wrap text when typing

" MISC SETTINGS
set foldlevelstart=99 " all folds open by default
" this makes sure that shell scripts are highlighted
" as bash scripts and not sh scripts
let g:is_posix = 1

" allow backspace and cursor keys to cross line boundaries
set whichwrap+=<,>,h,l
set backspace=2


" SEARCH SETTINGS
set nohlsearch " do not highlight searched-for phrases
set incsearch " ...but do highlight-as-I-type the search string
set gdefault " this makes search/replace global by default
if v:version >= 704
  " The new Vim regex engine is currently slooooow as hell which makes syntax
  " highlighting slow, which introduces typing latency.
  " Consider removing this in the future when the new regex engine becomes
  " faster.
  set regexpengine=1
endif


" WIDTH AND WHITESPACE SETTINGS
" show whitespace in cpph files
"set list listchars=tab:>-,trail:·,extends:>

" Show whitespace
" MUST be inserted BEFORE the colorscheme command
autocmd ColorScheme * highlight ExtraWhitespace ctermbg=black guibg=black
autocmd InsertLeave * match ExtraWhitespace /\s\+$/

" enforces a specified line-length and auto inserts hard line breaks when we
" reach the limit; in Normal mode, you can reformat the current paragraph with
" gqap.
set textwidth=80
 "this makes the color after the textwidth column highlighted
set colorcolumn=81
highlight ColorColumn ctermbg=233


" CLIPBOARD SETTINGS
if has('unnamedplus')
  " By default, Vim will not use the system clipboard when yanking/pasting to
  " the default register. This option makes Vim use the system default
  " clipboard.
  " Note that on X11, there are _two_ system clipboards: the "standard" one, and
  " the selection/mouse-middle-click one. Vim sees the standard one as register
  " '+' (and this option makes Vim use it by default) and the selection one as
  " '*'.
  " See :h 'clipboard' for details.
  set clipboard=unnamedplus,unnamed
else
  " Vim now also uses the selection system clipboard for default yank/paste.
  set clipboard+=unnamed
endif


" SPELLCHECKING SETTINGS
" set spell checking for certain filetypes
autocmd BufRead,BufNewFile *.md setlocal spell
autocmd FileType gitcommit setlocal spell


" FILETYPES SETTINGS
" add custom filetypes
au BufNewFile,BufRead *.launch set filetype=xml


"****************************  CUSTOM MAPS  ************************************
nmap <leader>fef :call Preserve("normal gg=G")<CR> " format all

" this makes vim's regex engine "not stupid"
" see :h magic
nnoremap / /\v
vnoremap / /\v

" <leader>v brings up .vimrc
" <leader>V reloads it and makes all changes active (file has to be saved first)
noremap <leader>v :e! $MYVIMRC<CR>
noremap <silent> <leader>V :source $MYVIMRC<CR>:filetype detect<CR>:exe ":echo 'vimrc reloaded'"<CR>

" g<c-]> is jump to tag if there's only one matching tag, but show list of
" options when there is more than one definition
nnoremap <leader>g g<c-]>

" Use Q for formatting the current paragraph (or visual selection)
vnoremap Q gq
nnoremap Q gqap

" This is quit all
noremap <leader>q :qa<cr>

" Toggle and untoggle spell checking
noremap <leader>se :setlocal spell! spelllang=en_us<cr>
noremap <leader>sg :setlocal spell! spelllang=el<cr>
" spelling shortcuts using <leader>
" ]s next misspelled word
" [s previous misspelled word
" zg add to dict
" z= get suggestions
noremap <leader>sn ]s
noremap <leader>sp [s
noremap <leader>sa zg
noremap <leader>ss z=

" Using '<' and '>' in visual mode to shift code by a tab-width left/right by
" default exits visual mode. With this mapping we remain in visual mode after
" such an operation.
vnoremap < <gv
vnoremap > >gv

 " reselect last paste
nnoremap <expr> gp '`[' . strpart(getregtype(), 0, 1) . '`]'

" Move to the end of line
noremap <leader>d $
" Move to the start of line
noremap <leader>a ^

" Clean all whitespace and save
map <Leader>ws :StripWhitespace<CR>:w<CR>

" New/close tab shortcut
map <leader>tn <Esc> :tabnew<CR>
map <leader>tc <Esc> :tabclose<CR>

 " remap arrow keys
nnoremap <c-up> :bprev<CR>
nnoremap <c-down> :bnext<CR>
nnoremap <c-right> :tabnext<CR>
nnoremap <c-left> :tabprev<CR>

" Bind Ctrl+<movement> keys to move around the windows,
" instead of using Ctrl+w + <movement>
nnoremap <s-right> <c-w>l
nnoremap <s-left> <c-w>h


"****************************  PLUGIN SETTINGS  ********************************
"****************************  Startify SETTINGS  ******************************
"let g:startify_session_dir = s:get_cache_dir('sessions')
let g:startify_change_to_vcs_root = 1
let g:startify_show_sessions = 1
nnoremap <F1> :Startify<cr>

"****************************  Syntastic SETTINGS  *****************************
let g:syntastic_error_symbol = '✗'
let g:syntastic_style_error_symbol = '✠'
let g:syntastic_warning_symbol = '∆'
let g:syntastic_style_warning_symbol = '≈'

"****************************  NERDTree SETTINGS  ******************************
" toggle NERDTree with Ctrl+n
map <C-n> :NERDTreeToggle<CR>
" TagBar SETTINGS
" toogle TagBar with <F8dfa>
nmap <F8> :TagbarToggle<CR>

" MatchTagAlways SETTINGS
" option for MatchTagAlways
let g:mta_use_matchparen_group = 1

"****************************  Fugitive SETTINGS  ******************************

nnoremap <silent> <leader>gs :Gstatus<CR>
nnoremap <silent> <leader>gd :Gdiff<CR>
nnoremap <silent> <leader>gc :Gcommit<CR>
nnoremap <silent> <leader>gb :Gblame<CR>
nnoremap <silent> <leader>gl :Glog<CR>
nnoremap <silent> <leader>gp :Git push<CR>
nnoremap <silent> <leader>gw :Gwrite<CR>
nnoremap <silent> <leader>gr :Gremove<CR>
autocmd BufReadPost fugitive://* set bufhidden=delete

"****************************  Unite SETTINGS  *********************************
" should install ack-grep
let g:unite_source_grep_command='ack-grep'
let g:unite_source_grep_default_opts='--no-heading --no-color -C4'
let g:unite_source_grep_recursive_opt=''
let g:unite_source_history_yank_enable = 1
call unite#filters#matcher_default#use(['matcher_fuzzy'])

nmap <leader> [unite]
nnoremap [unite] <nop>
" Unite shortcuts
nnoremap <silent> [unite]<space> :<C-u>Unite -toggle -auto-resize -buffer-name=mixed file_rec/async:! buffer file_mru bookmark<cr><c-u>
nnoremap <silent> [unite]f :<C-u>Unite -toggle -auto-resize -buffer-name=files file_rec/async:!<cr><c-u>
nnoremap <silent> [unite]e :<C-u>Unite -buffer-name=recent file_mru<cr>
nnoremap <silent> [unite]y :<C-u>Unite -buffer-name=yanks history/yank<cr>
nnoremap <silent> [unite]l :<C-u>Unite -auto-resize -buffer-name=line line<cr>
nnoremap <silent> [unite]b :<C-u>Unite -auto-resize -buffer-name=buffers buffer<cr>
nnoremap <silent> [unite]/ :<C-u>Unite -no-quit -buffer-name=search grep:.<cr>
nnoremap <silent> [unite]m :<C-u>Unite -auto-resize -buffer-name=mappings mapping<cr>
nnoremap <silent> [unite]s :<C-u>Unite -quick-match buffer<cr>
nnoremap <C-p> :Unite file_rec/async<cr>

"****************************  YouCompleteMe SETTINGS  *************************
let g:ycm_complete_in_comments_and_strings=1
let g:ycm_key_list_select_completion=['<C-n>', '<Down>']
let g:ycm_key_list_previous_completion=['<C-p>', '<Up>']
let g:ycm_filetype_blacklist={'unite': 1}

"****************************  UltiSnips SETTINGS  *****************************
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"
let g:UltiSnipsSnippetsDir='~/.vim/snippets'

"***************************  Sneak SETTINGS  **********************************
let g:sneak#streak = 1

"****************************  Python IDE Setup  *******************************
" Use pylint, should be installed
let g:syntastic_python_checkers = ['pylint', 'pep8', 'flake8']
let g:syntastic_python_python_exec = '/usr/bin/python2/'

" YouCompleteMe
let g:ycm_auto_trigger=1
let g:ycm_global_ycm_extra_conf='~/.vim/bundle/YouCompleteMe/third_party/ycmd/cpp/ycm/.ycm_extra_conf.py'

" Settings for ctrlp
let g:ctrlp_max_height = 30
set wildignore+=*.pyc
set wildignore+=*_build/*
set wildignore+=*/coverage/*
set wildignore+=*.o
set wildignore+=*~

" Settings for jedi-vim
"let g:jedi#usages_command = "<leader>z"
"let g:jedi#popup_on_dot = 0
"let g:jedi#popup_select_first = 0
"map <Leader>b Oimport ipdb; ipdb.set_trace() # BREAKPOINT<C-c>

" Better navigating through omnicomplete option list
" See http://stackoverflow.com/questions/2170023/how-to-map-keys-for-popup-menu-in-vim
set completeopt=longest,menuone
function! OmniPopup(action)
  if pumvisible()
    if a:action == 'j'
      return "\<C-N>"
    elseif a:action == 'k'
      return "\<C-P>"
    endif
  endif
  return a:action
endfunction

inoremap <silent><C-j> <C-R>=OmniPopup('j')<CR>
inoremap <silent><C-k> <C-R>=OmniPopup('k')<CR>

" Python folding
set nofoldenable

"****************************  Airline SETTINGS  *******************************
" vim-airline customization

" change default colors for airline
let g:airline_theme = 'kolor'

" enable powerline symbols, needs powerline fonts installed
let g:airline_powerline_fonts = 1
let g:airline_detect_modified = 1
let g:airline_detect_paste = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep=' '
let g:airline#extensions#tabline#left_alt_sep='¦'
" change default font for gvim to enable powerline symbols
if has('gui_running')
set guifont=DejaVu\ Sans\ Mono\ for\ Powerline\ 10
endif

"****************************  vim colorscheme themes  *************************
"let g:solarized_termcolors=256
"colorscheme solarized
colorscheme molokai

"****************************  IndentGuides SETTINGS  **************************
" change default indent color for IndentGuides
let g:indent_guides_start_level=1
let g:indent_guides_guide_size=1
let g:indent_guides_enable_on_vim_startup=0
let g:indent_guides_color_change_percent=3

" toggle indentGuides with <F7>
nmap <F7> <ESC>:IndentGuidesToggle<CR>

"****************************  VimShell SETTINGS  ******************************
let g:vimshell_editor_command='vim'
let g:vimshell_right_prompt='getcwd()'
"let g:vimshell_data_directory=s:get_cache_dir('vimshell')
let g:vimshell_vimshrc_path='~/.vim/vimshrc'
nnoremap <leader>cc :VimShell -split<cr>
nnoremap <leader>cr :VimShellInteractive irb<cr>
nnoremap <leader>cp :VimShellInteractive python<cr>
