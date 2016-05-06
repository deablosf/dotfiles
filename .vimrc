" Notes --------- {{{

" -----------------------------------------------------------
" Text object selection
" object-select OR text-objects
" delete the inner (...) block where the cursor is.
" dib ( or 'di(' )
" -----------------------------------------------------------
"
" -----------------------------------------------------------
" The default mapping is cp, and can be followed by any motion or text object. For instance:

" cpiw => copy word into system clipboard
" cpi' => copy inside single quotes to system clipboard
" In addition, cP is mapped to copy the current line directly.

" The sequence cv is mapped to paste the content of system clipboard to the next line.
" -----------------------------------------------------------
"
" -----------------------------------------------------------
"  Enable and disable folding
"  zi
" -----------------------------------------------------------
"
" }}}
" Leader mappings -------------------- {{{
let mapleader = ","
let maplocalleader = "\\"
" }}}
" Display settings ------------ {{{

" Enable buffer deletion instead of having to write each buffer
set hidden

" Remove GUI mouse support
" This support is actually annoying, because I may occasionally
" use the mouse to select text or something, and don't actually
" want the cursor to move
set mouse=""

" Automatically change directory to current file
" set autochdir

" Prevent creation of swap files
set nobackup
set noswapfile

set wrap

" Set column to light grey at 80 characters
if (exists('+colorcolumn'))
  set colorcolumn=80
  highlight ColorColumn ctermbg=9
endif

" Remove query for terminal version
" This prevents un-editable garbage characters from being printed
" after the 80 character highlight line
set t_RV=

filetype plugin indent on

" }}}
" Set number display ------------- {{{

function! ToggleRelativeNumber()
  if &rnu
    set norelativenumber
  else
    set relativenumber
  endif
endfunction

function! RNUInsertEnter()
  if &rnu
    let b:line_number_state = 'rnu'
    set norelativenumber
  else
    let b:line_number_state = 'nornu'
  endif
endfunction

function! RNUInsertLeave()
  if b:line_number_state == 'rnu'
    set relativenumber
  else
    set norelativenumber
  endif
endfunction

function! RNUBufEnter()
  if exists('b:line_number_state')
    if b:line_number_state == 'rnu'
      set relativenumber
    else
      set norelativenumber
    endif
  else
    set relativenumber
    set number
    let b:line_number_state = 'rnu'
  endif
endfunction

function! RNUBufLeave()
  if &rnu
    let b:line_number_state = 'rnu'
  else
    let b:line_number_state = 'nornu'
  endif
  set norelativenumber
endfunction

" Set mappings for relative numbers

" Toggle relative number status
nnoremap <silent><leader>r :call ToggleRelativeNumber()<CR>
augroup rnu_nu
  autocmd!
  " Don't have relative numbers during insert mode
  autocmd InsertEnter * :call RNUInsertEnter()
  autocmd InsertLeave * :call RNUInsertLeave()
  " Set and unset relative numbers when buffer is active
  autocmd BufNew,BufEnter * :call RNUBufEnter()
  autocmd BufLeave * :call RNUBufLeave()
augroup end

" }}}
" Vim-Plug Auto Load ----------------- {{{
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall | source $MYVIMRC
endif
" }}}
" Plugins --------------------- {{{
call plug#begin('~/.vim/plugged')

" Basics
Plug 'jeetsukumaran/vim-buffergator'
Plug 'dkprice/vim-easygrep'
Plug 'tpope/vim-fugitive'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'airblade/vim-rooter'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'qpkorr/vim-bufkill'
Plug 'christoomey/vim-system-copy'

" Surrounding things
Plug 'kana/vim-operator-user'
Plug 'rhysd/vim-operator-surround'
Plug 'kana/vim-textobj-user'
Plug 'rhysd/vim-textobj-anyblock'

" Static checking
Plug 'scrooloose/syntastic'

" Requirements for vimdeck
Plug 'vim-scripts/SyntaxRange'
Plug 'vim-scripts/ingo-library'

" Basic coloring
Plug 'bronson/vim-trailing-whitespace'
Plug 'tomasr/molokai'

" Utils
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-abolish'
Plug 'xolox/vim-misc'
Plug 'jiangmiao/auto-pairs'

" C-syntax
Plug 'justinmk/vim-syntax-extra'

" Language-specific syntax
Plug 'derekwyatt/vim-scala',
Plug 'wting/rust.vim'
Plug 'hdima/python-syntax',
Plug 'autowitch/hive.vim'
Plug 'elzr/vim-json',
Plug 'vimoutliner/vimoutliner'
Plug 'cespare/vim-toml'
Plug 'Glench/Vim-Jinja2-Syntax'
Plug 'plasticboy/vim-markdown'
Plug 'ElmCast/elm-vim'
Plug 'mopp/rik_octave.vim'
Plug 'ekalinin/Dockerfile.vim'
Plug 'StanAngeloff/php.vim'
Plug 'vim-scripts/SAS-Syntax'

" Indentation
Plug 'hynek/vim-python-pep8-indent'

" Web Development - Javascript
Plug 'pangloss/vim-javascript', { 'branch': 'develop' }
Plug 'mxw/vim-jsx'
Plug 'othree/javascript-libraries-syntax.vim'
Plug 'groenewege/vim-less'

" Web Development - General
Plug 'mattn/emmet-vim'
Plug 'edsono/vim-matchit'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-ragtag'

" Rainbow
Plug 'junegunn/rainbow_parentheses.vim'

call plug#end()
" }}}
" Configure vim-fugitive --------- {{{

" The following are key shortcuts which add commits
nnoremap <leader>ga :Git add %:p<CR><CR>
nnoremap <leader>gs :Gstatus<CR>
nnoremap <leader>gc :Gcommit -v -q<CR>
nnoremap <leader>gt :Gcommit -v -q %:p<CR>
nnoremap <leader>gd :Gdiff<CR>
nnoremap <leader>ge :Gedit<CR>
nnoremap <leader>gr :Gread<CR>
nnoremap <leader>gw :Gwrite<CR><CR>
nnoremap <leader>gl :silent! Glog<CR>:bot copen<CR>
nnoremap <leader>gp :Ggrep<Space>
nnoremap <leader>gm :Gmove<Space>
nnoremap <leader>gb :Git branch<Space>
nnoremap <leader>go :Git checkout<Space>
nnoremap <leader>gps :Dispatch! git push<CR>
nnoremap <leader>gpl :Dispatch! git pull<CR>

" }}}
" Configure Control-P ---------- {{{
let g:ctrlp_working_path_mode = 'a'
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
set wildignore+=*/tmp/*,*.so,*.swp,*.zip
set wildignore+=*\\tmp\\*,*.swp,*.zip,*.exe

" Custom ignore
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/]\.(git|hg|svn)$',
  \ 'file': '\v\.(exe|so|dll)$',
  \ 'link': 'some_bad_symbolic_links',
  \ }

let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']

" }}}
" Configure Operator Surround --------- {{{

" DANGER-> THIS USES RECURSIVE MAPPING; BUGS MAY ARISE BECAUSE OF THIS CHOICE
" operator mappings
map <silent>sa <Plug>(operator-surround-append)
map <silent>sd <Plug>(operator-surround-delete)
map <silent>sr <Plug>(operator-surround-replace)

" delete or replace most inner surround
nmap <silent>sdd <Plug>(operator-surround-delete)<Plug>(textobj-anyblock-a)
nmap <silent>srr <Plug>(operator-surround-replace)<Plug>(textobj-anyblock-a)
nmap <silent>saa <Plug>(operator-surround-append)<Plug>(textobj-anyblock-a)

" }}}
" Configure syntastic ----------- {{{
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_mode_map = {'mode': 'passive', 'active_filetypes': [], 'passive_filetypes': []}
let g:syntastic_python_python_exec = '/usr/bin/env python3'
let g:syntastic_python_checkers = ['flake8', 'pyflakes', 'pylint']
let g:syntastic_python_flake8_args = "--ignore=E123,E124,E126,E128,E302,E731"

nnoremap <leader>sc :write<CR> :SyntasticCheck<CR>
nnoremap <leader>sr :SyntasticReset<CR>
" }}}
" Configure Rainbow ------------- {{{
let g:rainbow#max_level = 16
let g:rainbow#pairs = [['{', '}'], ['(', ')'], ['[', ']']]
augroup rainbow_settings
  " Section to turn on rainbow parentheses
  autocmd!
  autocmd BufEnter,BufRead * :RainbowParentheses
  autocmd BufEnter,BufRead *.html,*.css :RainbowParentheses!
augroup END
" }}}
" Configure Airline ----------- {{{
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1
let g:airline_theme='powerlineish'
set laststatus=2
set ttimeoutlen=50
set noshowmode
" }}}
" Configure EasyGrep ---------- {{{

" Track the current file extension
let g:EasyGrepMode = 2

" User regular Grep, not VimGrep
let gEasyGrepCommand = 1

" Search the escaped string (eg, non-regex)
let g:EasyGrepPatternType = 'fixed'

" Enable recursive search by default
let g:EasyGrepRecursive = 1

" Make root of project the repository
" Current directory is made project repo by vim-rooter
let g:EasyGrepRoot = 'cwd'

" Ignore certain directories
let g:EasyGrepFilesToExclude = '*?/venv/*,' .
      \ '*?/__pycache__/*,' .
      \ '*?/node_modules/*,' .
      \ '*?/bin/*,' .
      \ '*?/target/*,' .
      \ '*?/instance/*,' .
      \ '*?/doc/*,' .
      \ '*?/data/*,' .
      \ '*?/dot/*,' .
      \ '*?/redis-stable/*,' .
      \ '*?\.conf,' .
      \ '*?/tests/*,' .
      \ '*?/logs/*,' .
      \ '*?/diagrams/*,' .
      \ '*?/data_templates/*'

" }}}
" Configure Auto Pairs ----------- {{{
" How to insert parens purely
" There are 3 ways
" 1. use Ctrl-V ) to insert paren without trigger the plugin.
" 2. use Alt-P to turn off the plugin.
" 3. use DEL or <C-O>x to delete the character insert by plugin.
" --- }}}
" Configure Additional Plugin constants ------------ {{{

" Set the javascript libraries that need syntax highlighting
let g:used_javascript_libs = 'jquery,requirejs,react'

" Python highlighting
let python_highlight_all = 1

" Ragtag on every filetype
let g:ragtag_global_maps = 1

"  }}}
"  File Explorer------------ {{{
augroup explorer_options
  " Note that this still retains the very first buffer
  " used by NetRW to show file listing. All the NetRW buffers
  " that were created later, do not appear in the buffer list.
  " Not a perfect solution, but I can live with it.
  autocmd FileType netrw setl bufhidden=wipe
augroup END
"  }}}
"  Zeal --------- {{{

" Zeal documentation functions to search zeal from both normal mode
" and visual mode
" Clean up these functions tomorrow to deal with more general cases
" of zeal documentation

function! s:get_visual_selection()
  " Helper function to get visual selection into a variable
  " Why is this not a built-in Vim script function?!
  " Taken from xolox on stackoverflow
  " http://stackoverflow.com/questions/1533565/
  " how-to-get-visually-selected-text-in-vimscript
  let [lnum1, col1] = getpos("'<")[1:2]
  let [lnum2, col2] = getpos("'>")[1:2]
  let lines = getline(lnum1, lnum2)
  let lines[-1] = lines[-1][: col2 - (&selection == 'inclusive' ? 1 : 2)]
  let lines[0] = lines[0][col1 - 1:]
  return join(lines, "\n")
endfunction

function! s:ZealString(docset, query)
  let cmd_begin = '!(pkill zeal || true) && (zeal --query '
  let doc_escape = shellescape(a:docset)
  let query_escape = shellescape(a:query)
  let cmd_end = ' &) > /dev/null'
  return cmd_begin . doc_escape . ':' . query_escape . cmd_end
endfunction

function! ZealNormal(docset)
  call inputsave()
  let docset = input("Zeal Docset: ", a:docset)
  let query = input("Zeal Query: ", expand('<cword>'))
  call inputrestore()
  let cmd = s:ZealString(docset, query)
  silent execute cmd
endfunction

function! ZealVisual(docset)
  call inputsave()
  let docset = input("Zeal Docset: ", a:docset)
  let query = input("Zeal Query: ", s:get_visual_selection())
  call inputrestore()
  let cmd = s:ZealString(docset, query)
  silent execute cmd
endfunction

" Key bindings for zeal functions
nnoremap <leader>z :call ZealNormal(&filetype)<CR><CR><c-l><CR>
vnoremap <leader>z :call ZealVisual(&filetype)<CR><CR><c-l><CR>

"  }}}
" Filetypes ------------ {{{
augroup filetype_recognition
  autocmd!
  autocmd BufNewFile,BufRead,BufEnter *.md,*.markdown set filetype=markdown
  autocmd BufNewFile,BufRead,BufEnter *.hql,*.q set filetype=hive
  autocmd BufNewFile,BufRead,BufEnter *.config set filetype=yaml
  autocmd BufNewFile,BufRead,BufEnter *.bowerrc,*.babelrc,*.eslintrc set filetype=json
  autocmd BufNewFile,BufRead,BufEnter *.handlebars set filetype=html
  autocmd BufNewFile,BufRead,BufEnter *.m,*.oct set filetype=octave
  autocmd BufNewFile,BufRead,BufEnter *.jsx set filetype=javascript.jsx
augroup END

" }}}
" General Key remappings ----------------------- {{{

" Move up and down visually only if count is specified before
" Otherwise, you want to move up lines numerically
" e.g. ignoring wrapped lines
nnoremap <expr> k v:count == 0 ? 'gk' : 'k'
nnoremap <expr> j v:count == 0 ? 'gj' : 'j'

" Move to beginning and end of visual line
nnoremap 0 g0
nnoremap $ g$
" Move line up and down with hyphen key
nnoremap - ddp
nnoremap _ ddkP

" Enable pasting without having to do 'set paste'
if &term =~ "xterm.*"
  let &t_ti = &t_ti . "\e[?2004h"
  let &t_te = "\e[?2004l" . &t_te
  function! XTermPasteBegin(ret)
    set pastetoggle=<Esc>[201~
    set paste
    return a:ret
  endfunction
  map <expr> <Esc>[200~ XTermPasteBegin("i")
  imap <expr> <Esc>[200~ XTermPasteBegin("")
  vmap <expr> <Esc>[200~ XTermPasteBegin("c")
  cmap <Esc>[200~ <nop>
  cmap <Esc>[201~ <nop>
endif

" Quickfix window automatically close after selecting file
augroup quickfix_sr
  autocmd!
  autocmd FileType qf silent! nnoremap <buffer> <CR> <CR>:cclose<CR>
augroup END
" }}}
" Folding Settings --------------- {{{
augroup fold_settings
  autocmd!
  autocmd FileType vim setlocal foldmethod=marker
  autocmd FileType vim setlocal foldlevelstart=0
  autocmd FileType javascript,c setlocal foldmethod=marker
  autocmd FileType javascript,c setlocal foldmarker={,}
  autocmd FileType * setlocal foldnestmax=1
augroup END
nnoremap z<space> zA

" }}}
" Vimscript file settings ------------------- {{{
augroup filetype_vim
  autocmd!
  autocmd BufWritePost *vimrc so $MYVIMRC | if has('gui_running') | so $MYGVIMRC | endif
augroup END
" }}}
" Smart insertion of semicolon and comma ------------ {{{

" Write both a placeholder (in this case l) and the closing character
" Escape to Normal mode, then move over the closing character
" Save current position to a mark called a
" Migrate to the matching opening character, saving position to mark b
" Move back to a, deleting closing character
" Move back to b
" Move to matching closing character
" Place either semicolon or comma at end
" Return to original cursor location
" inoremap <silent><C-l>} l}<Esc>ma%mb%`ax`b%a;<Esc>`aa<BS>
" inoremap <silent><C-l>] l]<Esc>ma%mb%`ax`b%a;<Esc>`aa<BS>
" inoremap <silent><C-l>) l)<Esc>ma%mb%`ax`b%a;<Esc>`aa<BS>

" inoremap <silent><C-l>}; l}<Esc>ma%mb%`ax`b%a;<Esc>`aa<BS>
" inoremap <silent><C-l>]; l]<Esc>ma%mb%`ax`b%a;<Esc>`aa<BS>
" inoremap <silent><C-l>); l)<Esc>ma%mb%`ax`b%a;<Esc>`aa<BS>

" inoremap <silent><C-l>}, l}<Esc>ma%mb%`ax`b%a,<Esc>`aa<BS>
" inoremap <silent><C-l>], l]<Esc>ma%mb%`ax`b%a,<Esc>`aa<BS>
" inoremap <silent><C-l>), l)<Esc>ma%mb%`ax`b%a,<Esc>`aa<BS>


" }}}
" Buffers and Windows ----------------- {{{
" Open with current file's root directory
nnoremap ;l :Explore <ENTER>
nnoremap ;j :bp <ENTER>
nnoremap ;k :bn <ENTER>
" Change change window thorough Control + directional movement
nnoremap <silent> <C-k> :wincmd k<CR>
nnoremap <silent> <C-j> :wincmd j<CR>
nnoremap <silent> <C-l> :wincmd l<CR>
nnoremap <silent> <C-h> :wincmd h<CR>
" Change change window width and height with capital movement letters
nnoremap <silent> K <c-w>+
nnoremap <silent> J <c-w>-
nnoremap <silent> H <c-w><
nnoremap <silent> L <c-w>>

" }}}
" Syntax coloring ---------------- {{{
try
  set t_Co=256 " says terminal has 256 colors
  let g:molokai_original = 1
  let g:rehash256 = 1
  colorscheme molokai
catch
endtry
" }}}
" Trailing whitespace ------------- {{{
augroup fix_whitespace_save
  let blacklist = ['markdown']
  autocmd BufWritePre * if index(blacklist, &ft) < 0 | execute ':FixWhitespace'
augroup END
" }}}
" Indentation ------------- {{{

" Note -> apparently BufRead, BufNewFile trumps Filetype
" Eg, if BufRead,BufNewFile * ignores any Filetype overwrites
" This is why default settings are chosed with Filetype *
augroup indentation_sr
  autocmd!
  autocmd Filetype * setlocal expandtab shiftwidth=2 softtabstop=2 tabstop=8
  autocmd Filetype python,c,elm setlocal shiftwidth=4 softtabstop=4 tabstop=8
  autocmd Filetype dot setlocal autoindent cindent
  autocmd BufRead,BufNewFile *.otl,*GNUmakefile,*makefile,*Makefile,*.tsv
        \ setlocal tabstop=4 softtabstop=0 shiftwidth=4 noexpandtab
  " Prevent auto-indenting from occuring
  autocmd Filetype yaml setlocal indentkeys-=<:>
augroup END
" }}}
" Writing ------------------ {{{
let g:vim_markdown_folding_disabled=1
let g:vim_markdown_no_default_key_mappings=1
augroup writing
  autocmd!
  autocmd FileType markdown :setlocal wrap linebreak nolist
  autocmd FileType markdown :setlocal colorcolumn=0
  autocmd BufNewFile,BufRead *.html,*.txt,*.tex :setlocal wrap linebreak nolist
  autocmd BufNewFile,BufRead *.html,*.txt,*.tex :setlocal colorcolumn=0
augroup END
" }}}
