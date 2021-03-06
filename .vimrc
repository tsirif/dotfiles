"**************************  VUNDLE SETTINGS  **********************************
" Things required for vundle setup
set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" VIM BUNDLE PLUGINS
Plugin 'VundleVim/Vundle.vim' " list Vundle itself as a bundle plugin
Plugin 'Valloric/MatchTagAlways' " highlighting html/xml pair tags
Plugin 'Valloric/YouCompleteMe' " Valloric's masterpiece for vim autocompletion
Plugin 'davidhalter/jedi-vim' " But i want jedi-vim's features too for python
Plugin 'tomasr/molokai' " Molokai theme for vim is fine (too much purple though)
Plugin 'zeis/vim-kolor' " Vim is better with kolor's colors
Plugin 'Shougo/neomru.vim' " Most Recent most-recently-used mechanism (unite dep)
Plugin 'scrooloose/nerdcommenter' " Easy comments by scrooloose
Plugin 'scrooloose/nerdtree' " Vim just got a file system explorer
Plugin 'scrooloose/syntastic' " Static check and linting
Plugin 'Xuyuanp/nerdtree-git-plugin' " Git status in nerd tree. Cool
Plugin 'majutsushi/tagbar' " Closest thing to fast class diagrams
Plugin 'SirVer/ultisnips' " Metacoding in vim
Plugin 'Shougo/vimproc.vim' " alternative vim lang, dep of unite
Plugin 'Shougo/vimshell.vim' " Get a shell in a vim buffer!
Plugin 'Shougo/unite.vim' " One plugin to unite them all. Cool utilities
Plugin 'vim-airline/vim-airline' " Funky bottomline and theming
Plugin 'vim-airline/vim-airline-themes' " Theeeeemes
Plugin 'edkolev/tmuxline.vim' " Funky bottomline everywhere!
Plugin 'ntpeters/vim-better-whitespace' " I don't want whitespaces in my code
Plugin 'tpope/vim-fugitive' " Git in vim
Plugin 'nathanaelkane/vim-indent-guides' " Show indentation in non-intrusive way
Plugin 'taketwo/vim-ros' " Easy catkin file navigation
Plugin 'mhinz/vim-signify' " Visualizing git diff actually
Plugin 'tsirif/vim-snippets' " Snippets for ultisnips metacoding (by my standards)
Plugin 'vim-scripts/vim-startify' " Starting session for vim
" Plugin 'ryanoasis/vim-devicons' " Make vim fancier with icons!!!
Plugin 'LaTeX-Box-Team/LaTeX-Box' " Latex helper
Plugin 'rhysd/vim-clang-format' " Easily lint C, C++, ObjC code
Plugin 'Firef0x/PKGBUILD.vim' " Make my AUR life easy

call vundle#end()
" Filetype Indentation Mode
filetype plugin indent on


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

" Enable syntax highlighting
syntax on
syntax enable

" Enable doxygen documentation highlighting
" let g:load_doxygen_syntax=1
let g:load_sphinx_syntax=1

" TMUX INTEGRATION SETTINGS
" Make Vim recognize XTerm escape sequences for Page and Arrow
" " keys combined with modifiers such as Shift, Control, and Alt.
" " See http://www.reddit.com/r/vim/comments/1a29vk/_/c8tze8p
if &term =~ '^screen'
  execute "set t_kP=\e[5;*~"
  execute "set t_kN=\e[6;*~"
  execute "set <xUp>=\e[1;*A"
  execute "set <xDown>=\e[1;*B"
  execute "set <xRight>=\e[1;*C"
  execute "set <xLeft>=\e[1;*D"
endif

" for mouse to work properly when using tmux
set ttymouse=xterm2

if $TMUX != ''
  " integrate movement between tmux/vim panes/windows

  fun! TmuxMove(direction)
    " Check if we are currently focusing on a edge window.
    " To achieve that,  move to/from the requested window and
    " see if the window number changed
    let oldw = winnr()
    silent! exe 'wincmd ' . a:direction
    let neww = winnr()
    silent! exe oldw . 'wincmd w'
    if oldw == neww
      " The focused window is at an edge, so ask tmux to switch panes
      if a:direction == 'j'
        call system("tmux select-pane -D")
      elseif a:direction == 'k'
        call system("tmux select-pane -U")
      elseif a:direction == 'h'
        call system("tmux select-pane -L")
      elseif a:direction == 'l'
        call system("tmux select-pane -R")
      endif
    else
      exe 'wincmd ' . a:direction
    end
  endfun

  function! TmuxSharedYank()
    " Send the contents of the 't' register to a temporary file, invoke
    " copy to tmux using load-buffer, and then to xclip
    " FIXME for some reason, the 'tmux load-buffer -' form will hang
    " when used with 'system()' which takes a second argument as stdin.
    let tmpfile = tempname()
    call writefile(split(@t, '\n'), tmpfile, 'b')
    call system('tmux load-buffer '.shellescape(tmpfile).';tmux show-buffer | xclip -i -selection clipboard')
    call delete(tmpfile)
  endfunction

  function! TmuxSharedPaste()
    " put tmux copy buffer into the t register, the mapping will handle
    " pasting into the buffer
    let @t = system('xclip -o -selection clipboard | tmux load-buffer -;tmux show-buffer')
  endfunction


  nnoremap <silent> <c-w>j :silent call TmuxMove('j')<cr>
  nnoremap <silent> <c-w>k :silent call TmuxMove('k')<cr>
  nnoremap <silent> <c-w>h :silent call TmuxMove('h')<cr>
  nnoremap <silent> <c-w>l :silent call TmuxMove('l')<cr>
  nnoremap <silent> <c-w><down> :silent call TmuxMove('j')<cr>
  nnoremap <silent> <c-w><up> :silent call TmuxMove('k')<cr>
  nnoremap <silent> <c-w><left> :silent call TmuxMove('h')<cr>
  nnoremap <silent> <c-w><right> :silent call TmuxMove('l')<cr>

  vnoremap <silent> <esc>y "ty:call TmuxSharedYank()<cr>
  vnoremap <silent> <esc>d "td:call TmuxSharedYank()<cr>
  nnoremap <silent> <esc>p :call TmuxSharedPaste()<cr>"tp
  vnoremap <silent> <esc>p d:call TmuxSharedPaste()<cr>h"tp
  set clipboard= " Use this or vim will automatically put deleted text into x11 selection('*' register) which breaks the above map

  " Quickly send text to a pane using f6
  nnoremap <silent> <f6> :SlimuxREPLSendLine<cr>
  inoremap <silent> <f6> <esc>:SlimuxREPLSendLine<cr>i " Doesn't break out of insert
  vnoremap <silent> <f6> :SlimuxREPLSendSelection<cr>

  " Quickly restart your debugger/console/webserver. Eg: if you are developing a node.js web app
  " in the 'serve.js' file you can quickly restart the server with this mapping:
  nnoremap <silent> <f5> :call SlimuxSendKeys('C-C " node serve.js" Enter')<cr>
  " pay attention to the space before 'node', this is actually required as send-keys will eat the first key

endif


" DISPLAY SETTINGS
set background=dark " enable for dark terminals
"set scrolloff=2 " 2 lines above/below cursor when scrollin
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
set nobackup " no backup~ files.
set noswapfile " no .swp files.
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
set spelllang=en_us,el
" set spellfile=$HOME/.vim/spell/en.utf-8.spl,$HOME/.vim/spell/el.utf-8.spl
" set spell checking for certain filetypes
autocmd BufRead,BufNewFile *.md setlocal spell
autocmd FileType gitcommit setlocal spell
autocmd BufRead,BufNewFile *.tex setlocal spell
autocmd BufRead,BufNewFile *.rst setlocal spell

" Change wrong spelling highlight color to be more readable (218 = pink)
" highlight SpellBad ctermbg=218
"
" greek language input - toggle with C-^
set keymap=greek_utf-8
set iminsert=0
set imsearch=-1
" <F2> also toggles
inoremap <F2> <C-^>

" FILETYPES SETTINGS
" add custom filetypes
autocmd BufNewFile,BufRead *.launch set filetype=xml
" avr IDE
autocmd BufNewFile,BufRead *.asm set filetype=avr8bit
autocmd BufNewFile,BufRead *.asm setlocal tabstop=4 shiftwidth=4 softtabstop=4
" sql
autocmd BufNewFile,BufRead *.sql setlocal tabstop=4 shiftwidth=4 softtabstop=4
" pkgbuild
autocmd BufNewFile,BufRead *.pb set filetype=PKGBUILD


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
noremap <leader>sl :setlocal spell!<CR>
noremap <leader>se :setlocal spell! spelllang=en_us<CR>
noremap <leader>sg :setlocal spell! spelllang=el<CR>
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
nnoremap <leader>' $
vnoremap <leader>' $
" Move to the start of line
nnoremap <leader>a ^
vnoremap <leader>a ^

" Clean all whitespace and save
map <silent> <Leader>ws :%s/\s\+$//<CR>:w<CR>

" New/close tab shortcut
map <leader>tn <Esc> :tabnew<CR>
map <leader>tc <Esc> :tabclose<CR>

" remap arrow keys
map <c-up> <Esc> :bprev<CR>
map <c-down> <Esc> :bnext<CR>
map <c-right> <Esc> :tabnext<CR>
map <c-left> <Esc> :tabprev<CR>

" Bind Ctrl+<movement> keys to move around the windows,
" instead of using Ctrl+w + <movement>
map <s-right> <Esc><c-w>l
map <s-left> <Esc><c-w>h

" Move half page up/down
nnoremap <c-j> <Esc><c-d>
vnoremap <c-j> <c-d>
nnoremap <c-k> <Esc><c-u>
vnoremap <c-k> <c-u>


"****************************  PLUGIN SETTINGS  ********************************
"****************************  Startify SETTINGS  ******************************
let g:startify_session_dir = "/home/tsirif/.vim-sessions"
let g:startify_change_to_vcs_root = 1
let g:startify_show_sessions = 1
let g:startify_bookmarks = [ '~/.vimrc', '~/.zshrc', '~/.tmux.conf' ]
nnoremap <F1> :Startify<cr>

"****************************  Syntastic SETTINGS  *****************************
let g:syntastic_error_symbol = '✗'
let g:syntastic_warning_symbol = '∆'
let g:syntastic_style_error_symbol = '✠'
let g:syntastic_style_warning_symbol = '≈'
let g:syntastic_cpp_check_header = 1
let g:syntastic_tex_chktex_args = "-n19"
let g:syntastic_enable_highlighting = 1
let g:syntastic_enable_signs = 1
let g:syntastic_always_populate_loc_list = 1

" Use {clang_check, gcc, make}
let g:syntastic_c_checkers = ['clang_check']
let g:syntastic_c_check_header = 1
let g:syntastic_c_auto_refresh_includes = 1
let g:syntastic_c_compiler = 'clang'

"****************************  NERDTree SETTINGS  ******************************
" toggle NERDTree with Ctrl+n
map <C-n> :NERDTreeToggle<CR>

"***************************  NERDTreeGit SETTINGS  ****************************
" custon configuration for icons
let g:NERDTreeIndicatorMapCustom = {
    \ "Modified"  : "✹",
    \ "Staged"    : "✚",
    \ "Untracked" : "✭",
    \ "Renamed"   : "➜",
    \ "Unmerged"  : "═",
    \ "Deleted"   : "✖",
    \ "Dirty"     : "✗",
    \ "Clean"     : "✔︎",
    \ "Unknown"   : "?"
    \ }

"****************************  NERDCommenter SETTINGS  *************************
" leave space after comment
let g:NERDSpaceDelims = 1

"****************************  TagBar SETTINGS  ********************************
" toogle TagBar with <F8dfa>
nmap <F8> :TagbarToggle<CR>

"****************************  MatchTagAlways SETTINGS  ************************
" option for MatchTagAlways
let g:mta_use_matchparen_group = 1
let g:mta_filetypes = {
    \ 'html' : 1,
    \ 'xhtml' : 1,
    \ 'xml' : 1,
    \ 'jinja' : 1,
    \ 'launch' : 1
    \}

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
if executable('ag')
  " Use ag (the silver searcher)
  " https://github.com/ggreer/the_silver_searcher
  let g:unite_source_grep_command = 'ag'
  let g:unite_source_grep_default_opts =
  \ '-i --vimgrep --hidden --ignore ' .
  \ '''.hg'' --ignore ''.svn'' --ignore ''.git'' --ignore ''.bzr'''
  let g:unite_source_grep_recursive_opt = ''
end
let g:unite_source_history_yank_enable=1
call unite#filters#matcher_default#use(['matcher_fuzzy'])
call unite#filters#sorter_default#use(['sorter_rank'])

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
nnoremap <C-p> :Unite file_rec/async<cr>

"****************************  YouCompleteMe (YCM) SETTINGS  ************************
let g:ycm_register_as_syntastic_checker = 1
let g:ycm_show_diagnostics_ui = 1

"will put icons in Vim's gutter on lines that have a diagnostic set.
"Turning this off will also turn off the YcmErrorLine and YcmWarningLine
"highlighting
let g:ycm_enable_diagnostic_signs = 1
let g:ycm_enable_diagnostic_highlighting = 1
let g:ycm_always_populate_location_list = 1 "default 0
let g:ycm_open_loclist_on_ycm_diags = 1 "default 1

let g:ycm_path_to_python_interpreter="/usr/bin/python"
let g:ycm_complete_in_comments_and_strings=0
let g:ycm_seed_identifiers_with_syntax=1
let g:ycm_collect_identifiers_from_comments_and_strings=1
let g:ycm_key_list_select_completion=['<tab>', '<Down>']
let g:ycm_key_list_previous_completion=['<s-tab>', '<Up>']

let g:ycm_auto_trigger=1
let g:ycm_global_ycm_extra_conf='~/homedir/.vim/.ycm_extra_conf.py'
let g:ycm_filetype_blacklist={'unite': 1}
"Configure Eclim and YCM integration
let g:EclimCompletionMethod = 'omnifunc'
let g:ycm_semantic_triggers = {
\   'roslaunch' : ['="', '$(', '/'],
\   'rosmsg,rossrv,rosaction' : ['re!^', '/'],
\ }

"****************************  UltiSnips SETTINGS  **********************************
"" Trigger configuration.
"" Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger="<c-j>"
let g:UltiSnipsJumpForwardTrigger="<c-j>"
let g:UltiSnipsJumpBackwardTrigger="<c-k>"
let g:UltiSnipsListSnippets="<c-`>"
let g:UltiSnipsSnippetDirectories=["UltiSnips", "private-snippets"]
" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"
let g:ultisnips_python_style="numpy"

" Unite - UltiSnips Integration
function! UltiSnipsCallUnite()
  Unite -start-insert -winheight=100 -immediately -no-empty ultisnips
  return ''
endfunction

inoremap <silent> <F12> <C-R>=(pumvisible()? "\<LT>C-E>":"")<CR><C-R>=UltiSnipsCallUnite()<CR>
nnoremap <silent> <F12> a<C-R>=(pumvisible()? "\<LT>C-E>":"")<CR><C-R>=UltiSnipsCallUnite()<CR>

"****************************  Python IDE Setup  *******************************
" Use {pycodestyle, pylint, pyflakes or flake8}
let g:syntastic_python_checkers = ['flake8', 'pylint', 'python']
let g:syntastic_python_python_exec = '/usr/bin/python'
" let g:syntastic_quiet_messages = { "level" : "warnings" }
" let g:syntastic_python_flake8_post_args = '--ignore=E123'

autocmd FileType python setlocal formatprg=autopep8\ -
autocmd FileType python setlocal equalprg=autopep8\ -

" Configure Eclim and Syntastic integration for python
let g:EclimPythonValidate = 0

" Settings for ctrlp
let g:ctrlp_max_height = 30
set wildignore+=*.pyc
set wildignore+=*_build/*
set wildignore+=*/coverage/*
set wildignore+=*.o
set wildignore+=*~

" Settings for jedi-vim
let g:jedi#usages_command = "<leader>z"
let g:jedi#popup_on_dot = 0
let g:jedi#popup_select_first = 0
let g:jedi#show_call_signatures_delay = 0
let g:jedi#show_call_signatures = "1"
map <Leader>br Oimport ipdb; ipdb.set_trace() # BREAKPOINT<C-c>

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

" inoremap <silent><C-j> <C-R>=OmniPopup('j')<CR>
" inoremap <silent><C-k> <C-R>=OmniPopup('k')<CR>

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
" if has('gui_running')
"   set guifont=Droid\ Sans\ Mono\ for\ Powerline\ Plus\ Nerd\ File\ Types\ 11
" endif

"****************************  IndentGuides SETTINGS  **************************
" change default indent color for IndentGuides
let g:indent_guides_start_level=2
" let g:indent_guides_guide_size=1
let g:indent_guides_enable_on_vim_startup=0
let g:indent_guides_color_change_percent=20
let g:indent_guides_auto_colors=0
" autocmd VimEnter,ColorScheme * highlight IndentGuidesOdd  ctermbg=2
autocmd VimEnter,ColorScheme * highlight IndentGuidesEven ctermbg=237

" toggle indentGuides with <F7>
nmap <F7> <ESC>:IndentGuidesToggle<CR>

"****************************  vim colorscheme themes  *************************
" colorscheme molokai
colorscheme kolor

"****************************  VimShell SETTINGS  ******************************
let g:vimshell_editor_command='vim'
let g:vimshell_right_prompt='getcwd()'
"let g:vimshell_data_directory=s:get_cache_dir('vimshell')
let g:vimshell_vimshrc_path='~/.vim/vimshrc'
nnoremap <leader>cs :VimShell -split<cr>
nnoremap <leader>cr :VimShellInteractive irb<cr>
nnoremap <leader>cp :VimShellInteractive ipython<cr>

"***************************  VimDevIcons SETTINGS  ****************************
let g:WebDevIconsUnicodeDecorateFolderNodes = 1

"***************************  clangFormat SETTINGS  ****************************
let g:clang_format#code_style = "google"
let g:clang_format#style_options = {
      \ "ConstructorInitializerIndentWidth" : 2,
      \ "ColumnLimit" : 80,
      \ "BreakBeforeBraces" : "Attach",
      \ "AccessModifierOffset" : -4,
      \ "AlwaysBreakTemplateDeclarations" : "true",
      \ "AllowShortIfStatementsOnASingleLine" : "false",
      \ "AllowShortCaseLabelsOnASingleLine" : "true",
      \ "AllowShortLoopsOnASingleLine" : "false",
      \ "IndentCaseLabels" : "false",
      \ "Standard" : "C++11"}

" map to <Leader>cf in C++ code
autocmd FileType c,cpp,cxx,objc nnoremap <buffer><Leader>cf :<C-u>ClangFormat<CR>
autocmd FileType c,cpp,cxx,objc vnoremap <buffer><Leader>cf :ClangFormat<CR>

"***************************  Latex-Box SETTINGS  ******************************
let g:LatexBox_latexmk_async = 0
let g:LatexBox_build_dir = "build"
let g:LatexBox_quickfix = 3
