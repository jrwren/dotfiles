# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
#export HISTCONTROL=ignoredups

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# enable color support of ls and also add handy aliases
if [[ "$TERM" != "dumb" ]]; then
    if [ ! -z "`which dircolors`" ]; then
        eval `dircolors -b`
        alias ls='ls --color=auto'
    else
        alias ls='ls -G'
    fi
    alias rt='ionice -c 3 rtorrent -O 'schedule=watchdir,0,1,load_start=*.torrent' -- *.torrent'
    alias tmuxa='tmux attach-session -t 0'
    alias phpman='man -M ~/pear/docs/pman'
	#alias less='less -r'
	# set PATH so it includes user's private bin if it exists
    #alias dir='ls --color=auto --format=vertical'
    #alias vdir='ls --color=auto --format=long'
fi
if [[ -d $HOME/bin ]] && ! echo $PATH | grep -q $HOME/bin ; then
    PATH=$HOME/bin:"${PATH}"
fi
if [[ ! -z $DISPLAY ]];then
    alias vi='vim -X'
    alias vim='vim -X'
fi
[[ -x "/Applications/MacVim.app/Contents/MacOS/Vim" ]] && alias vim=/Applications/MacVim.app/Contents/MacOS/Vim && alias vi=vim

if [[ -z "$HOSTNAME" ]]; then HOSTNAME=`hostname`;fi

# some more ls aliases
#alias ll='ls -l'
#alias la='ls -A'
#alias l='ls -CF'

# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(lesspipe)"

# set variable identifying the chroot you work in
if [[ -z "$debian_chroot" && -r /etc/debian_chroot ]]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# A color and a non-color prompt:
#PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w \$ '
#PS1='${debian_chroot:+($debian_chroot)}\e[1;31m[${PWD}:${WINDOW}${TMUX_PAIN}]\e[1;32m[\A]\e[m\e[1;36m\n[\u@\h:\$]\e[m '
if [[ "$ITERM_PROFILE" == "Default Light" ]]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;31m\]\u@\h\[\033[00m\]:{${WINDOW}${TMUX_PANE}}\[\033[01;34m\]\w\[\033[00m\]'
else
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:{${WINDOW}${TMUX_PANE}}\[\033[01;34m\]\w\[\033[00m\]'
fi

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*|screen*)
    if [[ ! -z "`find --version 2>/dev/null | grep GNU`" ]];then
        PROMPT_COMMAND='echo -ne "\033]0;${USER}@`hostname -s`: ${PWD}:${WINDOW}\007";export SSH_AUTH_SOCK=`find /tmp/ssh*  -type s -printf "%T+ %p\n" 2>/dev/null | head -1 | cut -f 2 -d " "`'
    else
        PROMPT_COMMAND='echo -ne "\033]0;${USER}@`hostname -s`: ${PWD}:${WINDOW}\007"'
    fi
    ;;
*)
    ;;
esac

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc).
if [[ -f /etc/bash_completion ]]; then
    . /etc/bash_completion
fi

if [[ -r ~/.keychain/$HOSTNAME-sh ]]; then
. ~/.keychain/$HOSTNAME-sh
fi

if [[ -r /etc/debian_version ]]; then
export DEBFULLNAME="Jay R. Wren"
export DEBEMAIL="jrwren@xmtp.net"
fi

export EMAIL="jrwren@xmtp.net"

export EDITOR=vim

if [[ -x /usr/bin/cdrecord ]]; then
export CDR_SPEED=16
fi

#pip completion, kinda cool
_pip_completion()
{
    COMPREPLY=( $( COMP_WORDS="${COMP_WORDS[*]}" \
                   COMP_CWORD=$COMP_CWORD \
                   PIP_AUTO_COMPLETE=1 $1 ) )
}
complete -o default -F _pip_completion pip

#fab completion, cool still
_fab_completion() {
    COMPREPLY=( $( \
    COMP_LINE=$COMP_LINE  COMP_POINT=$COMP_POINT \
    COMP_WORDS="${COMP_WORDS[*]}"  COMP_CWORD=$COMP_CWORD \
    OPTPARSE_AUTO_COMPLETE=1 $1 ) )
}
complete -o default -F _fab_completion fab

GIT_PS1_SHOWDIRTYSTATE=1
GIT_PS1_SHOWUPSTREAM="verbose svn"
if [[ -r ~/.git-completion.bash ]]; then
    source ~/.git-completion.bash
    PS1=$PS1'$(__git_ps1 " (%s)") '
elif [[ -r /usr/local/git/contrib/completion/git-completion.bash ]]; then
    source /usr/local/git/contrib/completion/git-completion.bash
    PS1=$PS1'$(__git_ps1 " (%s)") '
elif [[ -r /etc/bash_completion.d/git ]]; then
    source /etc/bash_completion.d/git
    PS1=$PS1'$(__git_ps1 " (%s)") '
fi

PS1=$PS1'$ '

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"  # This loads RVM into a shell session.

#[[ -s "$HOME/venv/bin/activate" ]] && source "$HOME/venv/bin/activate" # This uses a default python virtualenv
alias venv='source $HOME/venv/bin/activate'

hash brew 2>/dev/null && [[ -s `brew --prefix`/Library/Contributions/brew_bash_completion.sh ]] && source `brew --prefix`/Library/Contributions/brew_bash_completion.sh

complete -W "$(echo `cat ~/.ssh/known_hosts | cut -f 1 -d ' ' | sed -e s/,.*//g | uniq | grep -v "\["`;)" ssh

PROMPT_COMMAND="history -a;$PROMPT_COMMAND"

export LESS=FRSX

export JAVA_HOME="$(/usr/libexec/java_home)"
if [[ -r "$HOME"/.ec2/pk-*.pem ]];then
export EC2_PRIVATE_KEY="$(/bin/ls "$HOME"/.ec2/pk-*.pem | /usr/bin/head -1)"
fi
if [[ -r "$HOME"/.ec2/cert-*.pem ]];then
export EC2_CERT="$(/bin/ls "$HOME"/.ec2/cert-*.pem | /usr/bin/head -1)"
fi
if [[ -r /usr/local/Library/LinkedKeys/ec2-api-tools/jars ]];then
export EC2_HOME="/usr/local/Library/LinkedKegs/ec2-api-tools/jars"
fi
if [[ -r /usr/local/Cellar/ec2-ami-tools/1.3-45758/jars ]]; then
export EC2_AMITOOL_HOME="/usr/local/Cellar/ec2-ami-tools/1.3-45758/jars"
fi
eval "$(rbenv init -)"
[ -f ~/.bundler-exec.sh ] && source ~/.bundler-exec.sh
PATH=$PATH:/usr/local/share/npm/bin

#if I am at console, capslock should be ctrl
if `tty | grep -- '/dev/tty[1-6]'` ; then loadkeys jrw.kmap.gz ; fi

### Added by the Heroku Toolbelt
if [[ -x /usr/local/heroku/bin ]]; then export PATH="/usr/local/heroku/bin:$PATH" ;fi


if [[ "jwren13.local" == $HOSTNAME || "$HOSTNAME" =~ .*arbor.net$ ]]; then
    source .bashrc-arbor
fi
