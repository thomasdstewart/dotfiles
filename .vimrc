"take indent for new line from previous line (ai)
set autoindent

""dark" or "light", used for highlight colors (bg)
"set background=dark
set background=light

"no keep backup file after overwriting a file (bk)
set nobackup

"how backspace works at start of line (bs)
set backspace=indent,eol,start

"if gvim
if has("gui_running")
        "number of columns in the display (co)
        set columns=80
endif

"if gvimdiff
if (has("gui_running") && &foldmethod == 'diff')
        "number of columns in the display (co)
        set columns=151
        map :q :qa
endif

"type of encryption to use for file writing (cm)
set cryptmethod=blowfish2

"no behave Vi-compatible as much as possible (cp)
set nocompatible

"list of flags for how to display text (dy)
set display+=lastline "When included, as much as possible of the last line in a window will be displayed.  "@@@" is put in the last columns of the last screen line to indicate the rest of the line is not displayed.
set display+=uhex "Show unprintable characters hexadecimal as <xx> instead of using ^C and ~C.

"no ring the bell for error messages (eb)
set noerrorbells

"use spaces when <Tab> is inserted (et)
set expandtab

"switch on file type detection, with automatic indenting and setting
filetype plugin indent on

"GUI: Name(s) of font(s) to be used
set guifont=Monospace\ 10

"GUI: Which components and options are used (go)
set guioptions-=T "Include Toolbar. Currently only in Win32, GTK+, Motif, Photon and Athena GUIs
set guioptions-=t "Include tearoff menu items.  Currently only works for Win32, GTK+, and Motif 1.2 GUI.

"number of command-lines that are remembered (hi)
set history=10000

"highlight matches with last search pattern (hls)
set hlsearch

"ignore case in search patterns (ic)
set ignorecase

"highlight match while typing search pattern (is)
set incsearch

"tells when last window has status lines (ls)
set laststatus=2 "always

"wrap long lines at a blank (lbr)
set linebreak

"if gvim
if has("gui_running")
        "number of lines in the display
        set lines=50
endif

"show <Tab> and <EOL>
"set list

"characters for displaying in list mode (lcs)
set listchars=tab:→\ ,trail:·,precedes:«,extends:»,eol:¶

"recognize modelines at start or end of file (ml)
set modeline

"changes meaning of mouse buttons (mousem)
set mousemodel=popup_setpos

"print the line number in front of each line (nu)
"set number

"controls the format of :hardcopy output (popt)
set printoptions=paper:a4,left:5mm,right:5mm,top:5mm,bottom:5mm "portrait
"set printoptions=paper:a4,left:5mm,right:5mm,top:5mm,bottom:5mm,portrait:n,duplex:short "landscape
"set printdevice=Brother_HL_L2375DW_series

"number of spaces to use for (auto)indent step (ws)
set shiftwidth=8

"show (partial) command in status line (sc)
set showcmd

"briefly jump to matching bracket if insert one (sm)
set showmatch

"number of spaces that <Tab> uses while editing (sts)
set softtabstop=8

"language(s) to do spell checking for (spl)
set spelllang=en_GB

"custom format for the status line (stl)
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

"use .viminfo file upon startup and exiting (vi)
set viminfo='20,\"50

"use menu for command line completion (wmnu)
set wildmenu

"long lines wrap and continue on the next line
set wrap

"return to same place
autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

"custom file types
autocmd Filetype python setlocal sts=4 sw=4
autocmd Filetype yaml setlocal sts=2 sw=2

