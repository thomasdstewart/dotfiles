# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

shopt -s autocd
shopt -s cdspell
shopt -s checkjobs
shopt -s dirspell
shopt -s histverify
shopt -s no_empty_cmd_completion

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=20000
HISTFILESIZE=20000
HISTTIMEFORMAT="%Y-%m-%dT%H:%M:%S%z "

PROMPT_COMMAND="history -a;$PROMPT_COMMAND"

savehist () {
        FILENAME="history-${HOSTNAME}-$(date +%Y%m).txt"
        mkdir -p ~/.bash-history
        cat ~/.bash_history > ~/.bash-history/$FILENAME
}
trap ' [ "$PS1" ] && savehist ' 0

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

no_colour="\[\e[0m\]"

black="\[\e[0;30m\]"
darkred="\[\e[0;31m\]"
darkgreen="\[\e[0;32m\]"
darkyellow="\[\e[0;33m\]"
darkblue="\[\e[0;34m\]"
darkpurple="\[\e[0;35m\]"
darkcyan="\[\e[0;36m\]"
gray="\[\e[0;37m\]"

darkgray="\[\e[1;30m\]"
red="\[\e[1;31m\]"
green="\[\e[1;32m\]"
yellow="\[\e[1;33m\]"
blue="\[\e[1;34m\]"
purple="\[\e[1;35m\]"
cyan="\[\e[1;36m\]"
white="\[\e[1;37m\]"

username="${darkyellow}\u${no_colour}"
at="${black}@${no_colour}"
hostname="${darkgreen}\h${no_colour}"
workingdir="${darkcyan}\w${no_colour}"
if [ -f /etc/bash_completion.d/git-prompt ]; then
        . /etc/bash_completion.d/git-prompt
        GIT_PS1_SHOWDIRTYSTATE=1
        GIT_PS1_SHOWSTASHSTATE=1
        GIT_PS1_SHOWUNTRACKEDFILES=1
        GIT_PS1_SHOWUPSTREAM=verbose
        #gitstatus='$(__git_ps1 " (%s)")'
        gitstatus=''
else
        gitstatus=''
fi
nojobs="${darkgreen}\${jl}${no_colour}"
laststatus="${red}\`if [ \$? = "0" ]; then echo ''; else echo \"(\$?)\"; true; fi\`${no_colour}"
historynum="${darkred}\!${no_colour}"
prompt="${darkgreen}\\$"

dateandtime="${darkbrown}\$(date +'%H:%M %a %d/%m/%Y')${no_colour}"
smileface=" \|/ ____ \|/\n ~@-/ oO \-@~\n /_( \__/ )_\ \n    \__U_/\n"

case $(locale charmap) in
UTF-8)
        _smile_happy='☺ '
        _smile_frown='☹ '
        ;;
*)
        _smile_happy=':)'
        _smile_frown=':('
        ;;
esac
function smile {
        if [[ $? -eq 0 ]]; then
                printf "${_csi_green}${_smile_happy}"
        else
                printf "${_csi_red}${_smile_frown}"
        fi
}
function user_colour {
        if test "$UID" = 0; then
                printf "${_csi_red}"
        else
                printf "${_csi_green}"
        fi
}
_csi_default=$(tput sgr 0)
_csi_cyan=$(tput setaf 6)
_csi_green=$(tput setaf 2)
_csi_red=$(tput setaf 1)
_csi_gold=$(tput setaf 3)
#PS1="\n\$(smile) ${_csi_cyan}\\A $(user_colour)\\u@\\h ${_csi_gold}\\w$_csi_default \$(__git_ps1 '(%s)')\n\\$ "

export PROMPT_COMMAND="jl=; test \$(jobs | wc -l) -gt 0 && jl=\"(\$(jobs|wc -l))\";$PROMPT_COMMAND"

if [ "$color_prompt" = yes ]; then
    #PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
    #PS1="${debian_chroot:+($debian_chroot)}${green}\u@\h${no_color}:${blue}\w${no_color}\$ "
    PS1="${debian_chroot:+($debian_chroot)}${username}${at}${hostname} ${workingdir} ${nojobs}${laststatus}${historynum}${prompt}${no_colour} "
else
    #PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
    PS1="${debian_chroot:+($debian_chroot)}\u@\h \w \${jl}\`if [ \$? = "0" ]; then echo ''; else echo \"(\$?)\"; true; fi\`\!\$ "
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    #alias ls='ls --color=auto'
    alias ls='ls --color=auto -F -h'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
#alias ll='ls -l'
#alias la='ls -A'
#alias l='ls -CF'
alias l='ls'
alias ll='ls -l'
alias la='ls -a'
alias lla='ls -l -a'
alias lart='ls -l -a -r -t'
alias df='df -h'
alias '..'='cd ..'
alias '...'='cd ../..'
alias '....'='cd ../../..'
alias '.....'='cd ../../../..'
alias h='history | less'
alias hg='h | grep'
alias c=clear
alias j="jobs -l"
alias ai="sudo apt install"
alias ap="apt-cache policy "
alias odh='od -A x -t x1z'
alias auu='sudo su -c "set -x; apt-get update && apt-get upgrade && apt-get dist-upgrade && apt-get clean && apt-get autoremove && aptitude purge ~c && aptitude forget-new"'
#alias rdp='rdesktop -k en-gb -g 1024x768+0+0 -N -a 16 -z -x l '
alias rdp='/opt/FreeRDP/bin/xfreerdp /size:1024x768 /bpp:24 /cert-ignore +clipboard +fonts'
alias mkiso='mkisofs -R -r -l -J '
alias vi=vim
alias bc='bc -ql'
alias dig='dig +multi'
alias dstat='dstat --bw'
alias ping='ping -n'
alias rsync='rsync -h'

alias burniso="wodim -v dev=/dev/cdrw "
alias burndvd="growisofs -Z /dev/dvdrw="
alias blankcd="wodim -v dev=/dev/cdrw blank=fast"
alias mkiso='genisoimage -R -r -l -J '
burnfile() { mkiso "$*" | burniso - ; }
alias burnfiledvd="growisofs -Z /dev/dvdrw -R -r -l -J "$*""

alias moshberyl="mosh --ssh=\"nc -z -w1 beryl.stewarts.org.uk 222 2> /dev/null; ssh \" thomas@beryl.stewarts.org.uk"

#dquilt push -a
#dquilt new myPatch.diff
#dquilt add README
#dquilt refresh
#dquilt pop -a
alias dquilt='QUILT_PATCHES=debian/patches QUILT_REFRESH_ARGS="-p ab --no-timestamps --no-index" QUILT_NO_DIFF_INDEX=1 QUILT_NO_DIFF_TIMESTAMPS=1 QUILT_DIFF_ARGS="--color=auto" quilt'
complete -F _quilt_completion $_quilt_complete_opt dquilt


# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

export PAGER=less
export LESS="-F -i -M -R -S -x4 -X"
export EDITOR=vim
export NAME="Thomas Stewart"
export EMAIL="thomas@stewarts.org.uk"
export DEBFULLNAME="$NAME"
export DEBEMAIL="$EMAIL"

#if [ -z $http_proxy ]; then
#        RSYNC_PROXY="$http_proxy"
#else
#        nc -z 158.119.150.18 8080 &> /dev/null
#        if [ $? == 0 ]; then
#                export proxy="http://158.119.150.18:8080"
#                export no_proxy="localhost,127.0.0.0/8,::1,.bioinformatics,.pheunix,.phe.gov.uk,.hpa.org.uk,.nibsc.ac.uk,.mhapp.nhs.uk,158.119.0.0/16,212.219.216.0/22,192.168.0.0/16,10.0.0.0/8,172.16.0.0/12"
#                export NO_PROXY="$no_proxy"
#                export http_proxy="$proxy"
#                export https_proxy="$proxy"
#                export ftp_proxy="$proxy"
#                export HTTP_PROXY="$proxy"
#                export HTTPS_PROXY="$proxy"
#                export FTP_PROXY="$proxy"
#                export RSYNC_PROXY="$proxy"
#        fi
#fi

if [ -n "$DISPLAY" ]; then
        export BROWSER=firefox
else
        export BROWSER=www-browser
fi

command -v stty &>/dev/null && stty stop undef && stty start undef

psa() {
        ps axwwf --sort pid -o pid,ppid,nlwp,user,group,nice,%cpu,%mem,vsz,rss,tty,stat,start,bsdtime,command \
                | egrep --color=auto -i "^  PID|$1" | grep -v grep
}

ws () { wireshark $@& }

#http://cmrg.fifthhorseman.net/wiki/BashFunctions
# create temporary directory, and cd to it,
# copying in all specified files
function cdtemp {
    local TD=$(mktemp -d -t cdtemp.XXXXXX)
    if [ $TD ] ; then
        (
            [ $1 ] && cp -a $@ "$TD"
            cd "$TD" && "$SHELL"
        ) && rm -rf "$TD"
    fi
}
export -f cdtemp

function meat {
        grep -v -e '^[[:space:]]*#' -e '^$' $@
}
export -f meat

function watcha {
        while true; do 
                if "$@"; then
                        echo -e -n \'\a\'
                fi
                sleep 1
        done
}
export -f watcha

#https://github.com/yrro/dotfiles/blob/master/.bashrc
function envof {
        local file="/proc/${1:?Usage: $0 pid}/environ"
        local cmd=(cat "$file")
        test -r "$file" || cmd=(sudo "${cmd[@]}")
        "${cmd[@]}" | tr '\0' '\n' | cat -v
}

function debskew {
        apt-cache showsrc "$1" \
                | grep-dctrl . --show=binary -n \
                | tr ', ' '\n' \
                | sort -u \
                | xargs -r dpkg -l
}


man() {
    env \
    LESS_TERMCAP_mb=$'\E[01;33m' \
    LESS_TERMCAP_md=$'\E[01;31m' \
    LESS_TERMCAP_me=$'\E[0m' \
    LESS_TERMCAP_se=$'\E[0m' \
    LESS_TERMCAP_so=$'\E[01;42;30m' \
    LESS_TERMCAP_ue=$'\E[0m' \
    LESS_TERMCAP_us=$'\E[01;32m' \
    man "$@"
}

extract () {
        if [ -f "$1" ] ; then
                case "$1" in
                        *.tar.xz)    cmd="tar xvJf"       ;;
                        *.tar.bz2)   cmd="tar xvjf"       ;;
                        *.tar.gz)    cmd="tar xvzf"       ;;
                        *.bz2)       cmd="bunzip2"        ;;
                        *.rar)       cmd="rar x"          ;;
                        *.gz)        cmd="gunzip"         ;;
                        *.tar)       cmd="tar xvf"        ;;
                        *.tbz2)      cmd="tar xvjf"       ;;
                        *.lzma)      cmd="unlzma"         ;;
                        *.tgz)       cmd="tar xvzf"       ;;
                        *.zip)       cmd="unzip"          ;;
                        *.xz)        cmd="unxz"           ;;
                        *.Z)         cmd="uncompress"     ;;
                        *.7z)        cmd="7z x"           ;;
                        *.exe)       cmd="cabextract"     ;;
                        *)           echo "don't know how to extract '$1'..." ;;
                esac
                echo "Run: $cmd $1 (Ctrl-c to cancel)"
                read
                $cmd "$1"
        else
                echo "'$1' is not a valid file!"
        fi
}

tsdebsum () {
        cd /var/cache/apt/archives
        sudo rm -f /tmp/broken.log /var/cache/apt/archives/*.deb /var/cache/apt/archives/partial/*.deb
        for d in $(dpkg -l | grep ^ii | awk '{print $2}' | xargs) ; do
                sudo apt-get download "$d"
        done
        sudo debsums --all --silent --generate=all *.deb 2>&1 | tee /tmp/broken.log
        echo 'sudo apt-get --reinstall install $(cat /tmp/broken.log | rev | awk '{print $2}' | rev | sort | uniq | xargs)'
        cd -
}

tomstatus (){
        load="$(cat /proc/loadavg)"
        procs="$(ps auxww | wc -l)"
        users="$(who | wc -l)"
        mo="$(awk -F: '/model name/{print $2}' /proc/cpuinfo | sort | uniq -c \
                | sed 's/^ *\([0-9)]*\) */\1*/')"
        so="$(awk -F: '/physical id/{print $2}' /proc/cpuinfo | sort | uniq | wc -l \
                | awk '{print $1}')"
        co="$(awk -F: '/cpu cores/{print $2}' /proc/cpuinfo | sort | uniq | awk '{print $1}')"
        si="$(awk -F: '/siblings/{print $2}' /proc/cpuinfo | sort | uniq | awk '{print $1}')"
        echo "Load $load Procs $procs Users $users"
        echo "$mo So $so Co $co Si $si"

        (
                if [ "$(free -help 2>&1 | grep -- '-h' | wc -l)" -eq 0 ]; then
                        free="free -m"
                else
                        free="free -hm"
                fi
                $free | sed 's/total/type total/' | sed 's/://' | sed -e "s/\b\(.\)/\u\1/g"
                df -hlTP -x tmpfs -x devtmpfs | head -1 | sed 's/Mounted.*on/Mounted/'
                df -hlTP -x tmpfs -x devtmpfs | awk 'NR>1' | sort
        ) | column -t
        ip -o l | awk '{$1=""; print $0}' | grep -v "^ lo" | sed 's/[ \t][ \t]*/ /g' | sed 's/^ //' | sed 's/\\ //g'
        ip -4 -o addr | awk '{$1=""; print $0}' | grep -v "^ lo" | sed 's/[ \t][ \t]*/ /g' | sed 's/scope.*//' | sed 's/^ //'
        ip -4 -o route | sed 's/[ \t][ \t]*/ /g' | sed 's/proto kernel scope link //'
        ip -6 -o addr | awk '{$1=""; print $0}' | grep -v "^ lo" | sed 's/[ \t][ \t]*/ /g' | sed 's/scope.*//' | sed 's/^ //' | grep -v "inet6 fe80"
        ip -6 -o route | sed 's/[ \t][ \t]*/ /g' | sed 's/proto kernel scope link //' | grep -v "unreachable"
}
tomstatus

#https://github.com/yrro/dotfiles
updaterc () {
        cd ~
        #add muttrc
        #add .quiltrc-dpkg
        url="https://beryl.stewarts.org.uk/~thomas/noauth"
        key="hkaHdsSV3SxX9SAsiJAs0"
        for f in .bashrc .vimrc .screenrc .psqlrc; do
                wget -q -N -P ~ --no-check-certificate $url/.$key$f
                c="$(md5sum $f .$key$f | awk '{print $1}' | sort | uniq | wc -l)"
                if [ "$c" -eq 1 ]; then
                        rm -f ~/.$key$f
                elif [ "$c" -eq 2 ]; then
                        if [ .$key$f -nt $f ]; then
                                cp -v ~/$f ~/$f.$(date +%s)
                                mv -uv .$key$f $f
                        else
                                echo "conflict"
                                diff -u .$key$f $f
                        fi
                fi
        done
        source ~/.bashrc
}


