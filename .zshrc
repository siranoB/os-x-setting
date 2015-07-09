# created on 2014.06.30.
# updated on 2015.06.26.
#
# ... by jsc1463@gmail.com
#
# >> install oh-my-zsh
# $ git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
#
# >> append '/usr/local/bin/zsh' to /etc/shells
# $ sudo vi /etc/shells
#
# >> change shell
# $ chsh -s /usr/local/bin/zsh
#

# Path to your oh-my-zsh installation.
# (https://github.com/robbyrussell/oh-my-zsh)
export ZSH=$HOME/.oh-my-zsh

# If you would like oh-my-zsh to automatically update itself
# without prompting you
DISABLE_UPDATE_PROMPT="true"

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="risto"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
HIST_STAMPS="yyyy-mm-dd"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
#plugins=(osx git ruby rails)
plugins=(osx brew)

source $ZSH/oh-my-zsh.sh

# User configuration
umask 027
export DISPLAY=:0.0
export EDITOR="/usr/bin/vim"
export SVN_EDITOR="/usr/bin/vim"
export LANG="ko_KR.UTF-8"
export LC_ALL="ko_KR.UTF-8"
export TERM="xterm-color"
export CLICOLOR=true
export HISTCONTROL=erasedups
export HISTSIZE=10000

# common aliases
alias ls="ls -G"
alias ll="ls -G -l"
alias grep="grep --color=auto"
alias ctags='ctags -R --totals=yes'
alias fixopenwith='/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user'

# aliases for development
alias ngrep="sudo ngrep -q -W byline"
alias npm="sudo npm"
alias httpserver="ruby -rwebrick -e'WEBrick::HTTPServer.new(:Port => 8888, :DocumentRoot => Dir.pwd).start'"

# load zsh functions
# . ~/.zshfunc

# load extra aliases if exist
if [ -f ~/.other_aliases ]; then
	. ~/.other_aliases
fi

# for Xcode
#defaults write com.apple.xcode PBXCustomTemplateMacroDefinitions '{ORGANIZATIONNAME = "some_organization_name" ; }'


#####################
#  for development  #
#####################
	
# for ruby
#export RUBYOPT="-w -rubygems"
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"  # This loads RVM into a shell session.
export PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting

# XXX - for using my global Gemfile as fallback...
autoload -U add-zsh-hook
set-fallback-gemfile () {
	_search () {
		slashes=${PWD//[^\/]/}
		directory="$PWD"
		for (( n=${#slashes}; n>0; --n )); do
			test -e "$directory/$1" && echo "$directory/$1" && return 
			directory="$(dirname "$directory")"
		done
	}
	if [ `_search "Gemfile.lock"` ]; then	# XXX - check if 'Gemfile.lock' exists in any of direct-upper directories
		# using local Gemfile
		unset BUNDLE_GEMFILE
	else	# if no Gemfile is provided, use my own(system-wide?) one instead
		# using fallback Gemfile at $HOME/Gemfile
		export BUNDLE_GEMFILE=$HOME/Gemfile
	fi
}
add-zsh-hook chpwd set-fallback-gemfile

if [[ -z $TMUX ]]; then

	# for golang
	if [ -x "`which go`" ] ; then
		export GOROOT=`go env GOROOT`
		export GOPATH=$HOME/srcs/go
		export PATH="$PATH:$GOROOT/bin:$GOPATH/bin"
	fi

	# for java
	export JAVA_JVM_VERSION="1.6"
	export CLASSPATH=.

	# for node
	export NODE_PATH=/usr/local/lib/node_modules:/usr/local/share/npm/lib/node_modules
	export PATH="$PATH:/usr/local/share/npm/bin"

	# additional paths
	if [ -d "$HOME/bin" ] ; then
		export PATH="$PATH:$HOME/bin"
	fi

fi
