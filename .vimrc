" for english in gvim ui
set langmenu=none


function! BuildMDComposer(info)
    if a:info.status != 'unchanged' || a:info.force
        if has('nvim')
            !cargo build --release --locked
        else
            !cargo build --release --locked --no-default-features --features json-rpc
        endif
    endif
endfunction

function! s:goyo_enter()
    set linebreak
endfunction

function! s:goyo_leave()
    set nolinebreak
endfunction


call plug#begin('~/.vim/plugged')

Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle'}
Plug 'easymotion/vim-easymotion'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'mattn/emmet-vim'
Plug 'ap/vim-css-color' 

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

Plug 'romainl/Apprentice'
Plug 'dracula/Vim', { 'as': 'dracula' }

Plug 'python-mode/python-mode', { 'for': 'python', 'branch': 'develop'}
Plug 'rust-lang/rust.vim'
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' } 
Plug 'Valloric/YouCompleteMe', { 'do': './install.py --all' }
Plug 'euclio/vim-markdown-composer', { 'do': function('BuildMDComposer')  }
Plug 'NoahTheDuke/vim-just'

Plug 'junegunn/goyo.vim'

call plug#end()


" FINDING FILES:
" Search down into subfolders
" Provides tab-completion for all file-related tasks
set path+=**


let mapleader =","

" for base16 colorscheme
" let base16colorspace = 256 " Access colors present in 256 colorspace
set background=dark
colorscheme apprentice
set termwinsize=10x0  " sets initial size of a terminal window

set number           " display line numbers on the left
set relativenumber   " use relative to the current line numbering to display
syntax enable        " turn on all the magick, including explorer and syntax highlighting
set ruler            " turn on the ruller (status info) at the bottom of the screen
set splitbelow splitright " new window splits will be from below and from the right
set noequalalways    " turn off splits autoresize 

" set cursorline

" highlight search result
set hlsearch

" highlight when search is typing
set incsearch

" ENCODING:
set fileencoding=utf-8
set encoding=utf-8
set nobomb " using BOM is kinda bad practice, turn it off
" set termencoding=utf8


" REMAPPING:
" Esc to Ctrl+L
imap <C-L> <Esc>
vmap <C-L> <Esc>
" ESC to Alt+a
imap <A-a> <Esc>
" ESC to Alt+i
imap <A-i> <Esc>
" turning off highlighting after search
nnoremap <C-L> :noh<return><esc> 
" toggle NerdTree
nnoremap <C-\> :NERDTreeToggle<CR>
"
" turn on distraction free writing
nnoremap <LEADER>g :Goyo<return>

" KEYMAPPING RUSSIAN KEYBOARD:
set keymap=russian-jcukenwin
set iminsert=0
set imsearch=0
highlight lCursor guifg=NONE guibg=Cyan
" setlocal spell spelllang=ru_yo,en_us


" TAB SPACE SETTING:
set tabstop=4        " width of tab character
set expandtab        " space charecters when using tab
set shiftwidth=4     " > and <  moves 4 characters
" set softtabstop=4  " backspace delete whole 4spaced tab
set autoindent       " Automatically indent when adding a new line


" -------------------
" EASYMOTION SETTINGS:
" -------------------
let g:EasyMotion_do_mapping = 0 " Disable default mappings

" Jump to anywhere you want with minimal keystrokes, with just one key binding.
" `s{char}{label}`
nmap <C-f> <Plug>(easymotion-overwin-f)
" or
" `s{char}{char}{label}`
" Need one more keystroke, but on average, it may be more comfortable.
nmap <C-f> <Plug>(easymotion-overwin-f2)

" Turn on case insensitive feature
let g:EasyMotion_smartcase = 1

" JK motions: Line motions
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)
let g:EasyMotion_startofline = 0 " keep cursor column when jk motion

" HL motions: same line motions
map <Leader>l <Plug>(easymotion-lineforward)
map <Leader>h <Plug>(easymotion-linebackward)


" turn off the shadow when easymotion
" let g:EasyMotion_do_shade = 0
" how to highlight words when easymotion
" hi link EasyMotion Search

" -----------------
" AIRLINE SETTINGS:
" -----------------
" always showing statusbar
set laststatus=2

" setting airline theme
let g:airline_theme = 'google_dark'
" let g:airline_theme = 'base16_monokai'
" let g:airline_theme = 'base16_isotope'
" let g:airline_theme = 'base16_colors'
" let g:airline_theme = 'dark'

" using patched fonts from powerline
let g:airline_powerline_fonts = 1

" turn on tab managing
let g:airline#extentions#tabline#enabled = 1

" always show tabline
let g:airline#extentions#tabline#tab_min_count = 0

" if file have same name as already oppend one - show directory
let g:airline#extensions#tabline#formatter = 'unique_tail'

" " enable Syntastic integration
" let g:airline#extensions#syntastic#enabled = 1


" ---------------------
" PYTHON MODE SETTINGS:
" ---------------------
let g:pymode = 1
let g:pymode_python = 'python3' " by default it uses python2
let g:pymode_trim_whitespaces = 1
let g:pymode_options = 1
let g:pymode_options_max_line_length = 88  " like with black

let g:pymode_rope = 1
let g:pymode_rope_lookup_project = 0
let g:pymode_rope_refix = '<C-c>'
" let g:pymode_rope_project_root = ""
let g:pymode_rope_complete_on_dot = 0
let g:pymode_rope_completion = 1
let g:pymode_rope_completion_bind = '<C-Space>'
" let g:pymode_lint_ignore = ["E203"]
let g:pymode_lint_on_write = 0


" ---------------------
" RUST SETTINGS:
" ---------------------
" ycm path tu rust src
let g:ycm_rust_src_path = $RUST_SRC_PATH


if has("autocmd")
  " Enable file type detection
  filetype on

  " Syntax of these languages is fussy over tabs Vs spaces
  autocmd FileType make setlocal ts=8 sts=8 sw=8 noexpandtab
  autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab

  " Customisations based on house-style (arbitrary)
  autocmd FileType html setlocal ts=2 sts=2 sw=2 expandtab
  autocmd FileType css setlocal ts=2 sts=2 sw=2 expandtab
  autocmd FileType javascript setlocal ts=4 sts=4 sw=4 noexpandtab
  " build and run current go file
  autocmd FileType go nmap <Leader>r :GoRun %<CR>
  " to use pyling only on python files
  autocmd FileType python nmap <Leader>L :PymodeLint<CR>

  " Treat .rss files as XML
  autocmd BufNewFile,BufRead *.rss setfiletype xml

  " reload .vimrc after writing changes to disk
  autocmd! BufWritePost .vimrc source $MYVIMRC

  " distraction free mode
  autocmd! User GoyoEnter nested call <SID>goyo_enter()
  autocmd! User GoyoLeave nested call <SID>goyo_leave()

endif

if has("win32")

    " setting python environment variable
    "  let $PYTHONHOME = 'C:\Program Files\Miniconda3\'
    " let $PYTHONPATH = 'C:\Program Files\Miniconda3\DLLs;C:\Program Files\Miniconda3\Lib'

    " ycm path for python
    " let g:ycm_path_to_python_interpreter='C:\Program Files\Miniconda3\'


    " turn on completer for c++
    let g:ycm_global_ycm_extra_conf = "~/.vim/plugged/YouCompleteMe/third_party/ycmd/examples/.ycm_extra_conf.py"

    " should be env:TERM = 'posh' in the powershell profile to work
    " if ($term == 'posh')
    "     set shell=PowerShell
    "     set shellcmdflag=-ExecutionPolicy\ RemoteSigned\ -Command
    "     set shellquote=\"
    "     " shellxquote mustbe a literalspace character.
    "     " http://stackoverflow.com/questions/7605917/system-with-powershell-in-vim 
    "     set shellxquote= 


    "     colorscheme industry

    " endif

endif


if has("gui_running")
    
    set guioptions-=T " disable toolbar(T)
    set guioptions-=r " disable right scrollbar
    set guioptions-=L " disable left scrollbar
    set guioptions-=m " disable menu bar
    if has("gui_win32")
        set guifont=Hack:h14
        set guifont=mononoki:h14
        " set langmenu=en_US.UTF-8 " set the language of the menu (gvim)
        " language en


        " Enable directX font rendering 
        set renderoptions=type:directx,gamma:1.0,contrast:0.5,level:1,geom:1,renmode:4,taamode:1
    else
        set guifont=Hack\ 14
        set guifont=mononoki\ 14

    endif


    
endif
