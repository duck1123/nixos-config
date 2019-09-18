{ config, pkgs, ... }:

{
    programs.zsh.interactiveShellInit = ''
    export GOPATH=$HOME/go
    export PATH=$PATH:/usr/local/go/bin
    export PATH=$PATH:$GOPATH/bin
    export PATH=$PATH:$HOME/go_appengine
    export VENV=local
    export TERM=xterm-256color
    
    # Base16 Shell
    BASE16_SHELL="$HOME/.config/base16-shell/"
    [ -n "$PS1" ] && \
        [ -s "$BASE16_SHELL/profile_helper.sh" ] && \
            eval "$("$BASE16_SHELL/profile_helper.sh")"
    
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
    
    # Hide host name
    #export PS1="\W \$"
    export PS1="%~ \$"
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
