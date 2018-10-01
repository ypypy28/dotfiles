set nocompatible
filetype off


" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim/
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

" Add all plugins here
" ----------------------------------
" here we will be adding the plugins
" ----------------------------------
"  common
Plugin 'scrooloose/nerdtree'
Plugin 'matze/vim-move'
Plugin 'easymotion/vim-easymotion'
" Plugin 'scrooloose/syntastic'
Plugin 'rust-lang/rust.vim'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-commentary'
Plugin 'romainl/Apprentice'
Plugin 'Valloric/YouCompleteMe'
Plugin 'klen/python-mode'
" Plugin 'chriskempson/base16-vim' " base16 color schemes didn't work in cmd  :(
Plugin 'mattn/emmet-vim'
Plugin 'dracula/Vim'

call vundle#end()           " required
filetype plugin indent on   " required


" FINDING FILES:
" Search down into subfolders
" Provides tab-completion for all file-related tasks
set path+=**


let mapleader =","

" for base16 colorscheme
" let base16colorspace = 256 " Access colors present in 256 colorspace
set background=dark
colorscheme apprentice

set number           " left collon with numbers
syntax enable        " turn on all the magick, including explorer and syntax highlighting
set ruler            " turn on the ruller (status info) at the bottom of the screen

" set cursorline

" highlight search result
set hlsearch

" highlight when search is typing
set incsearch

" ENCODING:
set fileencoding=utf-8
set encoding=utf-8
set bomb
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

" --------------------
"  SYNTASTIC SETTINGS:
" --------------------
" set statusline+=%#warningmsg#
" set statusline+=%{SyntasticStatuslineFlag()}
" set statusline+=%*

let g:syntastic_always_populate_loc_list=1
let g:syntastic_auto_loc_list=1
let g:syntastic_check_on_open=1
let g:syntastic_check_on_wq=0
let g:syntastic_enable_signs=1
let g:syntastic_enable_balloons=1
let g:syntastic_python_checker=['flake8']


" -----------------
" AIRLINE SETTINGS:
" -----------------
" always showing statusbar
set laststatus=2

" setting airline theme
let g:airline_theme = 'base16_monokai'
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

" enable Syntastic integration
let g:airline#extensions#syntastic#enabled = 1


" ---------------------
" PYTHON MODE SETTINGS:
" ---------------------
let g:pymode = 1
let g:pymode_trim_whitespaces = 1
let g:pymode_options = 1


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

  " Treat .rss files as XML
  autocmd BufNewFile,BufRead *.rss setfiletype xml

  " reload .vimrc after writing changes to disk
  autocmd! BufWritePost .vimrc source $MYVIMRC


endif

if has("win32")

    " setting python environment variable
    "  let $PYTHONHOME = 'C:\Program Files\Miniconda3\'
    " let $PYTHONPATH = 'C:\Program Files\Miniconda3\DLLs;C:\Program Files\Miniconda3\Lib'

    " ycm path for python
    " let g:ycm_path_to_python_interpreter='C:\Program Files\Miniconda3\'

    " ycm path tu rust src
    let g:ycm_rust_src_path = '~\.rust_src\rust\src'

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
    
    set guioptions-=T
    set guifont=Hack:h12
    set guifont=mononoki:h12
    " set langmenu=en_US.UTF-8 " set the language of the menu (gvim)
    " language en

    if has("gui_win32")

        " Enable directX font rendering 
        set renderoptions=type:directx,gamma:1.0,contrast:0.5,level:1,geom:1,renmode:4,taamode:1

    endif


    
endif

