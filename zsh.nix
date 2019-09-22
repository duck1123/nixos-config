{ config, pkgs, ... }:

{
    programs.zsh.interactiveShellInit = ''
    export GOPATH=$HOME/go
    export PATH=$PATH:/usr/local/go/bin
    export PATH=$PATH:$GOPATH/bin
    export PATH=$PATH:$HOME/go_appengine
    # Add nix profile to path
    export PATH=$PATH:/home/blake/.nix-profile/bin
    export VENV=local
    export TERM=xterm-256color

    # Hide host name
    export PS1="%~ \$"
    
    # Tomorrow Night color scheme
    color00="1d/1f/21" # Base 00 - Black
    color01="cc/66/66" # Base 08 - Red
    color02="b5/bd/68" # Base 0B - Green
    color03="f0/c6/74" # Base 0A - Yellow
    color04="81/a2/be" # Base 0D - Blue
    color05="b2/94/bb" # Base 0E - Magenta
    color06="8a/be/b7" # Base 0C - Cyan
    color07="c5/c8/c6" # Base 05 - White
    color08="96/98/96" # Base 03 - Bright Black
    color09=$color01 # Base 08 - Bright Red
    color10=$color02 # Base 0B - Bright Green
    color11=$color03 # Base 0A - Bright Yellow
    color12=$color04 # Base 0D - Bright Blue
    color13=$color05 # Base 0E - Bright Magenta
    color14=$color06 # Base 0C - Bright Cyan
    color15="ff/ff/ff" # Base 07 - Bright White
    color16="de/93/5f" # Base 09
    color17="a3/68/5a" # Base 0F
    color18="28/2a/2e" # Base 01
    color19="37/3b/41" # Base 02
    color20="b4/b7/b4" # Base 04
    color21="e0/e0/e0" # Base 06
    color_foreground="c5/c8/c6" # Base 05
    color_background="1d/1f/21" # Base 00
    
    if [ -n "$TMUX" ]; then
      # Tell tmux to pass the escape sequences through
      # (Source: http://permalink.gmane.org/gmane.comp.terminal-emulators.tmux.user/1324)
      put_template() { printf '\033Ptmux;\033\033]4;%d;rgb:%s\033\033\\\033\\' $@; }
      put_template_var() { printf '\033Ptmux;\033\033]%d;rgb:%s\033\033\\\033\\' $@; }
      put_template_custom() { printf '\033Ptmux;\033\033]%s%s\033\033\\\033\\' $@; }
    elif [ "''\$''\{TERM%%[-.]*''\}" = "screen" ]; then
      # GNU screen (screen, screen-256color, screen-256color-bce)
      put_template() { printf '\033P\033]4;%d;rgb:%s\007\033\\' $@; }
      put_template_var() { printf '\033P\033]%d;rgb:%s\007\033\\' $@; }
      put_template_custom() { printf '\033P\033]%s%s\007\033\\' $@; }
    elif [ "''\${TERM%%-*}" = "linux" ]; then
      put_template() { [ $1 -lt 16 ] && printf "\e]P%x%s" $1 $(echo $2 | sed 's/\///g'); }
      put_template_var() { true; }
      put_template_custom() { true; }
    else
      put_template() { printf '\033]4;%d;rgb:%s\033\\' $@; }
      put_template_var() { printf '\033]%d;rgb:%s\033\\' $@; }
      put_template_custom() { printf '\033]%s%s\033\\' $@; }
    fi
    
    # 16 color space
    put_template 0  $color00
    put_template 1  $color01
    put_template 2  $color02
    put_template 3  $color03
    put_template 4  $color04
    put_template 5  $color05
    put_template 6  $color06
    put_template 7  $color07
    put_template 8  $color08
    put_template 9  $color09
    put_template 10 $color10
    put_template 11 $color11
    put_template 12 $color12
    put_template 13 $color13
    put_template 14 $color14
    put_template 15 $color15
    
    # 256 color space
    put_template 16 $color16
    put_template 17 $color17
    put_template 18 $color18
    put_template 19 $color19
    put_template 20 $color20
    put_template 21 $color21
    
    put_template_var 10 $color_foreground
    if [ "$BASE16_SHELL_SET_BACKGROUND" != false ]; then
      put_template_var 11 $color_background
      if [ "''\$''\{TERM%%-*''\}" = "rxvt" ]; then
        put_template_var 708 $color_background # internal border (rxvt)
      fi
    fi
    put_template_custom 12 ";7" # cursor (reverse video)
    
    # clean up
    unset -f put_template
    unset -f put_template_var
    unset -f put_template_custom
    unset color00
    unset color01
    unset color02
    unset color03
    unset color04
    unset color05
    unset color06
    unset color07
    unset color08
    unset color09
    unset color10
    unset color11
    unset color12
    unset color13
    unset color14
    unset color15
    unset color16
    unset color17
    unset color18
    unset color19
    unset color20
    unset color21
    unset color_foreground
    unset color_background
    # End colors config

    export MAVEN_OPTS="-Xmx4096m -Xss1024m -XX:MaxPermSize=128m"
    export ANT_OPTS="-Xms512m -Xmx1024m"
    
    export WORKON_HOME=$HOME/.virtualenvs
    export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python
    
    export M2_HOME=/usr/local/Cellar/maven30/3.0.5/libexec
    
    # Set up the prompt
    
    setopt histignorealldups sharehistory
    
    # Use emacs keybindings even if our EDITOR is set to vi
    bindkey -e
    
    # Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
    HISTSIZE=1000
    SAVEHIST=1000
    HISTFILE=~/.zsh_history
    
    # Use modern completion system
    autoload -Uz compinit
    compinit
    
    zstyle ':completion:*' auto-description 'specify: %d'
    zstyle ':completion:*' completer _expand _complete _correct _approximate
    zstyle ':completion:*' format 'Completing %d'
    zstyle ':completion:*' group-name ''\'''\'
    zstyle ':completion:*:default' list-colors ''\$''\{''\(s.:.)LS_COLORS''\}
    zstyle ':completion:*' list-colors ""
    zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
    zstyle ':completion:*' matcher-list ''\'' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*''\'
    zstyle ':completion:*' menu select=long
    zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
    zstyle ':completion:*' use-compctl false
    zstyle ':completion:*' verbose true
    
    zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
    zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'
    
    export DEFAULT_USER=`whoami`
    
    export WORKON_HOME=$HOME/.virtualenvs
    
    # use more up-to-date ctags
    export PATH=$PATH:/usr/local/bin/ctags
    
    alias tmux="TERM=screen-256color-bce tmux"
    
    alias sudo='sudo '
    if [ -x "$(command -v nvim)" ]; then
    	alias vi=nvim
    fi
    
    alias ddev="pub run dart_dev"
    
    function myip() {
        MYIP=`ifconfig | grep -A 3 en0: | grep "inet " | awk '{ print $2 }'`
        echo "$MYIP"
    }
    
    function pubblame() {
        pub get --packages-dir --verbosity solver | grep 'inconsistent' -A 2 | sed -e 's/\ |//g'
    }
    
    portwho() {
        lsof -n -i:$1 | grep LISTEN
    }
    
    dt-format() {
        pub run dart_dev format
    }
    export PATH=$PATH:~/.pub-cache/bin
    
    alias woman=man
    alias ls='ls --color=auto'
    
    gocover() {
        go test "$1" -coverprofile=coverage.out
        go tool cover -html=coverage.out
    }
    
    alias ddown='docker stop $(docker ps -a -q); docker rm $(docker ps -a -q)'
    alias docker_kill='docker stop $(docker ps -aq)'
    nukedocker(){
      echo
      echo "Stop all containers"
      docker stop $(docker ps -a -q)
      echo
      echo "Delete all containers"
      docker rm $(docker ps -a -q)
       echo
       echo "Delete all images"
       docker rmi $(docker images -q)
       echo
       echo "Delete all volumes"
       rm -rf /var/lib/docker/volumes/*
       rm -rf /var/lib/docker/vfs/dir/*
       echo
       echo "Delete Final Docker Shiz"
       rm ~/Library/Containers/com.docker.docker/Data/com.docker.driver.amd64-linux/Docker.qcow2
       echo
       echo
       echo "Finished nuking"
     }
    
    # Docker
    function docker-stop() {
        # Stop all containers
        echo "Stopping docker containers..."
        docker stop $(docker ps -a -q)
    }
    function docker-rm() {
        docker-stop
        # Delete all containers
        echo "Removing docker containers..."
        docker rm -f $(docker ps -a -q)
    }
    function docker-rm-networks() {
        docker-stop
        # Delete all networks
        echo "Removing docker networks..."
        docker network rm $(docker network ls -q -f 'type=custom')
    }
    function docker-rm-volumes() {
        docker-stop
        # Delete all networks
        echo "Removing docker volumes..."
        docker volume rm $(docker volume ls -q)
    }
    function docker-clean() {
        docker-rm
        docker-rm-networks
        docker-rm-volumes
        # Delete all images
        echo "Removing docker images..."
        docker rmi -f $(docker images -q)
    }
    
    source $HOME/.cargo/env
    '';
}
