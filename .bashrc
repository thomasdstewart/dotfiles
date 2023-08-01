# shellcheck disable=SC2148
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
    cat ~/.bash_history > "$HOME/.bash-history/$FILENAME"
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
export PAGER=less
export LESS="-F -i -M -R -x4 -X"

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

function __ps1 {
    laststatus=$?

    #no_color=$(tput sgr 0)
    #black=$(tput setaf 0)
    #darkred=$(tput setaf 1)
    #darkgreen=$(tput setaf 2)
    #darkyellow=$(tput setaf 3)
    #darkblue=$(tput setaf 4)
    #darkpurple=$(tput setaf 5)
    #darkcyan=$(tput setaf 6)
    #gray=$(tput setaf 7)
    #darkgray=$(tput setaf 8)
    #red=$(tput setaf 9)
    #green=$(tput setaf 10)
    #yellow=$(tput setaf 11)
    #blue=$(tput setaf 12)
    #purple=$(tput setaf 13)
    #cyan=$(tput setaf 14)
    #lightgray=$(tput setaf 15)

    #for n in $(seq 0 256); do echo -en "$(tput setaf $n)colour $n\t"; done
    #colortest="${black}black${no_color} ${darkred}darkred${no_color} ${darkgreen}darkgreen${no_color} ${darkyellow}darkyellow${no_color} ${darkblue}darkblue${no_color} ${darkpurple}darkpurple${no_color} ${darkcyan}darkcyan${no_color} ${gray}gray${no_color} ${darkgray}darkgray${no_color} ${red}red${no_color} ${green}green${no_color} ${yellow}yellow${no_color} ${blue}blue${no_color} ${purple}purple${no_color} ${cyan}cyan${no_color} ${lightgray}lightgray${no_color}"; echo $colortest

    no_colour="\[\e[0m\]"
    black="\[\e[0;30m\]"
    darkred="\[\e[0;31m\]"
    darkgreen="\[\e[0;32m\]"
    darkyellow="\[\e[0;33m\]"
    #darkblue="\[\e[0;34m\]"
    #darkpurple="\[\e[0;35m\]"
    darkcyan="\[\e[0;36m\]"
    #gray="\[\e[0;37m\]"
    #darkgray="\[\e[1;30m\]"
    red="\[\e[1;31m\]"
    #green="\[\e[1;32m\]"
    #yellow="\[\e[1;33m\]"
    #blue="\[\e[1;34m\]"
    #purple="\[\e[1;35m\]"
    #cyan="\[\e[1;36m\]"
    #white="\[\e[1;37m\]"

    if [ "$UID" -eq 0 ]; then
        username="${red}\u${no_colour}"
    else
        username="${darkyellow}\u${no_colour}"
    fi

    at="${black}@${no_colour}"
    hostname="${darkgreen}\h${no_colour}"

    if [ -x /bin/systemctl ]; then 
        if [ "$(systemctl --version | awk '/systemd/{print $2}')" -ge 215 ]; then
            systemdstatus=$(systemctl is-system-running)
            if [ "$systemdstatus" != running ]; then
                systemdstatus=${red}\(${systemdstatus}\)${no_colour}
            else
                systemdstatus=
            fi
        fi
    fi

    workingdir="${darkcyan}\w${no_colour}"

    if [ -f /etc/bash_completion.d/git-prompt ]; then
        # shellcheck disable=SC1091
        . /etc/bash_completion.d/git-prompt
        # shellcheck disable=SC2034
        GIT_PS1_SHOWDIRTYSTATE=1
        # shellcheck disable=SC2034
        GIT_PS1_SHOWSTASHSTATE=1
        # shellcheck disable=SC2034
        GIT_PS1_SHOWUNTRACKEDFILES=1
        # shellcheck disable=SC2034
        GIT_PS1_SHOWUPSTREAM=verbose
        gitstatus="$(__git_ps1 "(%s)")"
    else
        gitstatus=''
    fi

    #if [ "$OS_AUTH_URL" != "" ]; then
    #    openstack="($( echo $OS_USERNAME | awk -F'@' '{print $1}')/$OS_TENANT_NAME$OS_PROJECT_NAME@$(echo $OS_AUTH_URL | awk -F'[/.:]' '{print $4}'))"
    #else
        openstack=""
    #fi

    if [ "$VIRTUAL_ENV" != "" ]; then
        venv=["$(basename "$VIRTUAL_ENV")"]
    else
        venv=""
    fi

    nojobs=$(jobs | wc -l)
    if [ "$nojobs" -gt 0 ]; then
        nojobs=${darkgreen}\($nojobs\)${no_colour}
    else
        nojobs=""
    fi

    noscreens=$(pgrep -cf ^SCREEN$)
    if [ "$noscreens" -gt 0 ]; then
        noscreens=${darkyellow}\(${noscreens}\)${no_colour}
    else
        noscreens=""
    fi

    if [ "$laststatus" -ne 0 ]; then
        laststatus=${red}\($laststatus\)${no_colour}
    else
        laststatus=""
    fi

    historynum="${darkred}\!${no_colour}"
    prompt="${darkgreen}\\$"

    export PS1="${debian_chroot:+($debian_chroot)}${username}${at}${hostname}$systemdstatus ${workingdir} ${venv}${gitstatus}${openstack}${nojobs}${noscreens}${laststatus}${historynum}${prompt}${no_colour} "

    case "$TERM" in
    xterm*|rxvt*)
        export PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
        ;;
    *)
        ;;
    esac
}
PROMPT_COMMAND="__ps1;$PROMPT_COMMAND"

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
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
    #test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    eval "$(dircolors -b)"
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
export DPKG_COLORS=auto

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
alias odh='od -A x -t x1z'
alias ai="sudo apt install"
alias aie="sudo apt -t experimental install"
alias ap="apt-cache policy "
#alias auu='sudo su -c "set -x; apt-get update && apt-get -y upgrade && apt-get dist-upgrade && aptitude full-upgrade && apt-get clean && apt-cache gencaches && apt-get autoremove && aptitude purge ~c && aptitude forget-new"'
alias auu=$'sudo bash -c "set -ex; apt update; apt upgrade; apt full-upgrade; apt clean; apt autoremove; apt-cache gencaches; aptitude full-upgrade; aptitude purge ~c; aptitude forget-new; aptitude search ~o || true; aptitude search \'~S~i!~Odebian\' || true"'
#alias rdp='rdesktop -k en-gb -g 1024x768+0+0 -N -a 16 -z -x l '
alias rdp='xfreerdp /size:1024x768 /bpp:24 /cert-ignore +clipboard +fonts'
alias mkiso='mkisofs -R -r -l -J '
alias vi=vim
alias bc='bc -ql'
alias dig='dig +multi'
alias dstat='dstat --bw'
alias ping='ping -n'
alias rsync='rsync -h'
if [ "$(ip help 2>&1 | grep -c -- -c)" -eq 1 ]; then
    alias ip='ip -c'
fi
alias noproxy='unset HTTP_PROXY https_proxy http_proxy ftp_proxy FTP_PROXY no_proxy NO_PROXY HTTPS_PROXY'

alias burniso="wodim -v dev=/dev/sr0 "
alias burndvd="growisofs -Z /dev/sr0="
alias blankcd="wodim -v dev=/dev/sr0 blank=fast"
alias mkiso='genisoimage -R -r -l -J '
burnfile() { mkiso "$*" | burniso - ; }
alias burnfiledvd="growisofs -Z /dev/sr0 -R -r -l -J "

# shellcheck disable=SC2139
alias justssh="ssh -oCiphers=+$(ssh -Q cipher | xargs | sed 's/ /,/g') -oMACs=+$(ssh -Q mac  | xargs | sed 's/ /,/g') -oHostKeyAlgorithms=+$(ssh -Q key | xargs | sed 's/ /,/g') -oKexAlgorithms=+$(ssh -Q kex | xargs | sed 's/ /,/g')"
alias sshp="ssh -o PreferredAuthentications=password"

#https://news.ycombinator.com/item?id=20245913
#jq -r 'tostream | select(length > 1) | ( .[0] | map( if type == "number" then "[" + tostring + "]" else "." + .  end) | join("")) + " = " + (.[1] | @json)'
alias jqf="jq -r 'tostream | select(length > 1) | ( .[0] | map( if type == \"number\" then \"[\" + tostring + \"]\" else \".\" + .  end) | join(\"\")) + \" = \" + (.[1] | @json)'"


alias myip="dig -4 +short ip @dns.toys | xargs"

#dquilt push -a
#dquilt new myPatch.diff
#dquilt add README
#dquilt refresh
#dquilt pop -a
alias dquilt='QUILT_PATCHES=debian/patches QUILT_REFRESH_ARGS="-p ab --no-timestamps --no-index" QUILT_NO_DIFF_INDEX=1 QUILT_NO_DIFF_TIMESTAMPS=1 QUILT_DIFF_ARGS="--color=auto" quilt'
#complete -F _quilt_completion $_quilt_complete_opt dquilt


# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    # shellcheck disable=SC1090
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        # shellcheck disable=SC1091
        . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        # shellcheck disable=SC1091
        . /etc/bash_completion
    fi
fi

export EDITOR=vim
export NAME="Thomas Stewart"
export EMAIL="thomas@stewarts.org.uk"
export DEBFULLNAME="$NAME"
export DEBEMAIL="$EMAIL"
export TZ="Europe/London"

#if [ -z $http_proxy ]; then
#    RSYNC_PROXY="$http_proxy"
#else
#    nc -z 158.119.150.18 8080 &> /dev/null
#    if [ $? == 0 ]; then
#        export proxy="http://158.119.150.18:8080"
#        export no_proxy="localhost,127.0.0.0/8,::1,.bioinformatics,.pheunix,.phe.gov.uk,.hpa.org.uk,.nibsc.ac.uk,.mhapp.nhs.uk,158.119.0.0/16,212.219.216.0/22,192.168.0.0/16,10.0.0.0/8,172.16.0.0/12"
#        export NO_PROXY="$no_proxy"
#        export http_proxy="$proxy"
#        export https_proxy="$proxy"
#        export ftp_proxy="$proxy"
#        export HTTP_PROXY="$proxy"
#        export HTTPS_PROXY="$proxy"
#        export FTP_PROXY="$proxy"
#        export RSYNC_PROXY="$proxy"
#    fi
#fi

if [ -n "$DISPLAY" ]; then
    export BROWSER=firefox
else
    export BROWSER=www-browser
fi

command -v stty &>/dev/null && stty stop undef && stty start undef

_unit=""
if [ "$(echo -en "3.3.10\n$(ps -V | rev | awk '{print $1}' | rev)" | sort -t. -n -k3 -k2 -k1 | head -1)" == "3.3.10" ]; then
    _unit="unit,"
fi
_label=""
if [ -x /usr/sbin/getenforce ]; then
    if [ "$(/usr/sbin/getenforce)" != "Disabled" ]; then
        _label="label,"
    fi
fi
psa() {
    # shellcheck disable=SC2009
    #ps axwwf --sort pid -o pid,ppid,nlwp,user:16,group,${_unit}${_label}nice,%cpu,%mem,vsz,rss,tty,stat,start,bsdtime,command \
    ps axwwf -o pid,ppid,nlwp,user:16,group,${_unit}${_label}nice,%cpu,%mem,vsz,rss,tty,stat,start,bsdtime,command \
        | grep -v grep | grep -E --color=auto -i "^[ ]*PID|$1"
}

ws () { wireshark "$@" & }

function lsblka {
    echo "lsblk -a"
    lsblk -a

    echo "lsblk -a -f (Output info about filesystems)"
    lsblk -a -f

    echo "lsblk -a -m (Output info about device owner, group and mode)"
    lsblk -a -m

    echo "lsblk -a -S (Output info about SCSI devices only)"
    lsblk -a -S

    echo "lsblk -a -t (Output info about block-device topology)"
    lsblk -a -t
    
    echo "lsblk -a -D -d (Print information about the discarding capabilities)"
    lsblk -a -D

    echo "lsblk -a -z -d (Print the zone model for each device)"
    lsblk -a -z
    
    #echo "lsblk -a -o (Other fields:)"
    lsblk -a -o NAME,DAX,FSSIZE,FSUSED,HOTPLUG,KNAME,PARTFLAGS,PARTLABEL,PARTTYPE,PARTTYPENAME,PARTUUID,PATH,PKNAME,PTTYPE,PTUUID,RAND,STATE,SUBSYSTEMS,WWN

    #lsblk -O | head -1 | sed 's/ /\n/g' | sort | uniq | egrep -v "^$(lsblka | grep ^NAME | sed 's/ /\n/g' | sort | uniq | grep -v "^$" | xargs | sed "s# #\$|^#g")\$" | xargs | sed 's/ /,/g'
}

#http://cmrg.fifthhorseman.net/wiki/BashFunctions
# create temporary directory, and cd to it,
# copying in all specified files
function cdtemp {
    TD="$(mktemp -d -t cdtemp.XXXXXX)"
    if [ "$TD" ]; then
        ([ "$1" ] && cp -a "$@" "$TD"
        cd "$TD" && "$SHELL"
        ) && rm -rf "$TD"
    fi
}
export -f cdtemp

function meat {
    grep -v -e '^[[:space:]]*#' -e '^$' "$@"
}
export -f meat

function watcha {
    while true; do 
        printf "\033c"
        date
        "$@" || echo -en "\a"
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
            *.tar.xz)    ecmd="tar xvJf"       ;;
            *.tar.bz2)   ecmd="tar xvjf"       ;;
            *.tar.gz)    ecmd="tar xvzf"       ;;
            *.bz2)       ecmd="bunzip2"    ;;
            *.rar)       ecmd="rar x"      ;;
            *.gz)    ecmd="gunzip"     ;;
            *.tar)       ecmd="tar xvf"    ;;
            *.tbz2)      ecmd="tar xvjf"       ;;
            *.lzma)      ecmd="unlzma"     ;;
            *.tgz)       ecmd="tar xvzf"       ;;
            *.zip)       ecmd="unzip"      ;;
            *.xz)    ecmd="unxz"       ;;
            *.Z)     ecmd="uncompress"     ;;
            *.7z)    ecmd="7z x"       ;;
            *.exe)       ecmd="cabextract"     ;;
            *)       echo "don't know how to extract '$1'..." ;;
        esac
        echo "Run: $ecmd $1 (Ctrl-c to cancel)"
        read -r
        $ecmd "$1"
    else
        echo "'$1' is not a valid file!"
    fi
}

tsdebsum () {
    (cd /var/cache/apt/archives || exit
    sudo rm -f /tmp/broken.log /var/cache/apt/archives/*.deb /var/cache/apt/archives/partial/*.deb
    for d in $(dpkg -l | grep ^ii | awk '{print $2}' | xargs) ; do
        sudo apt-get download "$d"
    done
    sudo debsums --all --silent --generate=all ./*.deb 2>&1 | tee /tmp/broken.log
    # shellcheck disable=SC2016,SC1083,SC2086
    echo 'sudo apt-get --reinstall install $(cat /tmp/broken.log | rev | awk '{print $2}' | rev | sort | uniq | xargs)')
}

tomstatus () {
    grep PRETTY_NAME /etc/*-release | awk -F= '{print $2}' | xargs
    uname -a
    load="$(cat /proc/loadavg)"
    procs="$(ps auxww | wc -l)"
    users="$(who | wc -l)"
    echo "Load $load Procs $procs Users $users"

    model="$(awk -F: '/model name/{print $2}' /proc/cpuinfo | sort | uniq -c \
        | sed 's/^ *\([0-9)]*\) */\1*/' | sed 's/  \+/ /g')"
    sockets="$(awk -F: '/physical id/{print $2}' /proc/cpuinfo | sort | uniq | wc -l)"
    cores="$(awk -F: '/core id/{print $2}' /proc/cpuinfo | wc -l)"
    #siblings="$(awk -F: '/siblings/{print $2}' /proc/cpuinfo | sort | uniq | awk '{print $1}')"
    ht=""
    test "$cores" != "$cores" && ht="HT"
    echo "$model Sockets $sockets Cores $cores $ht"

    vm="$(grep -q "^flags.*hypervisor" /proc/cpuinfo && echo vm || echo phy)"
    sv="$(cat /sys/class/dmi/id/sys_vendor)"
    pn="$(cat /sys/class/dmi/id/product_name)"
    pv="$(cat /sys/class/dmi/id/product_version)"
    echo "System ($vm): $sv $pn $pv"

    (
        if [ "$(free -help 2>&1 | grep -c -- '-h')" -eq 0 ]; then
            free="free -m"
        else
            free="free -hm"
        fi
        $free | sed 's/total/type total/' | sed 's/://' | sed -e "s/\b\(.\)/\u\1/g"
        df -hlTP -x tmpfs -x devtmpfs | head -1 | sed 's/Mounted.*on/Mounted/'
        df -hlTP -x tmpfs -x devtmpfs | awk 'NR>1' | sort
    ) | column -t
    ip="ip"
    if [ "$(ip help 2>&1 | grep -c -- -c)" -eq 1 ]; then
        ip="ip -c"
    fi
    $ip -o l | awk '{$1=""; print $0}' | grep -v "^ lo" | sed 's/[ \t][ \t]*/ /g' | sed 's/^ //' | sed 's/\\ //g' | sed 's/mtu.*\(link\)\///' | sed 's/brd.*//'
    $ip -4 -o addr | awk '{$1=""; print $0}' | grep -v "^ lo" | sed 's/[ \t][ \t]*/ /g' | sed 's/scope.*//' | sed 's/^ //'
    $ip -4 -o route | sed 's/[ \t][ \t]*/ /g' | sed 's/proto kernel scope link //'
    $ip -6 -o addr | awk '{$1=""; print $0}' | grep -v "^ lo" | sed 's/[ \t][ \t]*/ /g' | sed 's/scope.*//' | sed 's/^ //' | grep -v "inet6 fe80"
    $ip -6 -o route | sed 's/[ \t][ \t]*/ /g' | sed 's/proto kernel scope link //' | grep -v "unreachable" | grep -v "^fe80::/64"
}
tomstatus

updaterc () {
    if [ -d ~/dotfiles/ ]; then
        ~/dotfiles/iau
        ~/.dotfiles/iau
        return
    fi

    indexolderthanaweek=$(find ~/.dotfiles/.git/index -mtime +7 | wc -l)
    if [ "$indexolderthanaweek" -eq 1 ]; then
        echo "updating dotfiles"
        if ! (~/.dotfiles/iau); then
            echo failed
            return
        fi
        touch ~/.dotfiles/.git/index 
        echo "done"
        return
    fi
}
updaterc


hibp () {
    echo -n "Password:"
    read -rs pass
    h="$(echo -en "$pass" | sha1sum - | cut -c1-40)"
    h1="$(echo "$h" | cut -c 1-5)"
    h2="$(echo "$h" | cut -c 6-40)"
    curl -s https://api.pwnedpasswords.com/range/"$h1" | grep -i "$h2"
    echo
}

pgen () {
    if [ -z "$1" ]; then
        len=32
    else
        len=$1
    fi
    tr -cd '[:alnum:]' < /dev/urandom | head -c"$len"
    echo
}

killssh () {
    for s in ~/.ssh/master*; do
        s=$(echo "$s" | awk -F@ '{print $2}' | awk -F: '{print $1}')
        echo "$s"
        ssh -O exit "$s"
    done
}

makenetns () {
    mkdir -p /var/run/netns; for f in /proc/*/ns/net; do ln -sf "$f" /var/run/netns/"$(readlink "$f")"; done
}

#echo 1 > /proc/sys/kernel/sysrq
#echo s > /proc/sysrq-trigger
#echo b > /proc/sysrq-trigger


#docker ps -a | awk '{print $1}' | grep -v CONTAINER | xargs docker rm; docker images | awk '{print $3}' | grep -v IMAGES | xargs docker rmi -f
#podman ps -a | awk '{print $1}' | grep -v CONTAINER | xargs podman rm; podman images | awk '{print $3}' | grep -v IMAGES | xargs podman rmi -f

# vim: ts=4 sts=4 sw=4 
