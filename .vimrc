"take indent for new line from previous line
set autoindent

""dark" or "light", used for highlight colors
set background=light
"set background=dark

"no keep backup file after overwriting a file
set nobackup

"how backspace works at start of line
set backspace=indent,eol,start

"number of columns in the display
if has("gui_running")
        set columns=80
endif

"type of encryption to use for file writing
"set cryptmethod=blowfish2

"no behave Vi-compatible as much as possible
set nocompatible

"list of flags for how to display text
set display+=lastline "as much as possible of the last line in a window
set display+=uhex "Show unprintable characters hexadecimal as <xx>

"use spaces when <Tab> is inserted
set expandtab

"no ring the bell for error messages
set noerrorbells

"make gvimdiff wide
if (has("gui_running") && &foldmethod == 'diff')
        set columns=151
        map :q :qa
        endif

"type of file, used for autocommands
filetype plugin on

"GUI: Name(s) of font(s) to be used
set guifont=Monospace\ 10

"GUI: Which components and options are used
set guioptions-=T "Toolbar
set guioptions-=t "tearoff menu items.

"number of command-lines that are remembered
set history=10000

"highlight matches with last search pattern
set hlsearch

"highlight match while typing search pattern
set incsearch

"ignore case in search patterns
set ignorecase	

"tells when last window has status lines
set laststatus=2 "always

"wrap long lines at a blank
set linebreak

"characters for displaying in list mode
set listchars=extends:>,precedes:<

"number of lines in the display
if has("gui_running")
        set lines=50
endif

"changes meaning of mouse buttons
set mousemodel=popup_setpos

"print the line number in front of each line
"set number

"controls the format of :hardcopy output
set printoptions=paper:a4,left:5mm,right:5mm,top:5mm,bottom:5mm
"set printoptions=paper:a4,left:5mm,right:5mm,top:5mm,bottom:5mm,portrait:n,duplex:short

"show cursor line and column in the status line
"set ruler

"show (partial) command in status line
set showcmd

"briefly jump to matching bracket if insert one
set showmatch

"number of spaces that <Tab> uses while editing
set softtabstop=8

"language(s) to do spell checking for
set spelllang=en_GB

"custom format for the status line
set statusline=%<%F\ %m%r%h%w%y[%{&ff}]%=%l/%L:%c\ %{FileSize()}\ %p%%
function! FileSize()
        let bytes = getfsize(expand("%:p"))
        if bytes <= 0
                return ""
        endif
        if bytes < 1024
                return bytes
        else
                return (bytes / 1024) . "k"
        endif
endfunction

"syntax to be loaded for current buffer
syntax on

"maximum width of text that is being inserted
"set textwidth=80
set textwidth=0

"use .viminfo file upon startup and exiting
set viminfo='20,\"50

"use menu for command line completion
set wildmenu

"long lines wrap and continue on the next line
set wrap

"map up, down, home and end keys in normal
map <up> gk
map <down> gj
map <home> g<home>
map <end> g<end>
   
"map up, down, home and end keys in insert mode
imap <up> <C-o>gk
imap <down> <C-o>gj
imap <home> <C-o>g<home>
imap <end> <C-o>g<end>

"Make p in Visual mode replace the selected text with the "" register.
vnoremap p <Esc>:let current_reg = @"<CR>gvdi<C-R>=current_reg<CR><Esc>

"http://paulrouget.com/e/myvimrc/
au BufRead mutt-* set fo+=a

"from r9mm868
":highlight hred ctermbg=red guibg=red
":highlight hgreen ctermbg=green guibg=green
":highlight hyellow ctermbg=yellow guibg=yellow
":highlight hblue ctermbg=blue guibg=blue
":highlight hpurple ctermbg=purple guibg=purple
"characters for displaying in list mode
"set listchars=extends:>,precedes:<
"highlight WhitespaceEOL ctermbg=lightgray guibg=lightgray
"match WhitespaceEOL /s+$/ 
":highlight DiffAdd cterm=none ctermfg=bg ctermbg=Green gui=none guifg=bg guibg=Green
":highlight DiffDelete cterm=none ctermfg=bg ctermbg=Red gui=none guifg=bg guibg=Red
":highlight DiffChange cterm=none ctermfg=bg ctermbg=Yellow gui=none guifg=bg guibg=Yellow
":highlight DiffText cterm=none ctermfg=bg ctermbg=Magenta gui=none guifg=bg guibg=Magenta

let g:xml_syntax_folding = 1
au FileType xml setlocal fdm=syntax
