#--- Load setting
autoload -U compinit
autoload -U promptinit
autoload -U colors && colors
autoload -U zsh-mime-setup
autoload -U zcalc

#--- Define functions here ---------------------------------------------
function prompt_char {
    git branch >/dev/null 2>/dev/null && echo '±' && return
    hg root >/dev/null 2>/dev/null && echo '☿' && return
    echo '○'
}

#--- End of functions --------------------------------------------------

#--- command completion
compinit

#--- color prompt
promptinit

#--- MIME setup
zsh-mime-setup

#--- auto completion of command line switches for aliases
setopt completealiases

#--- auto change directory if given directory
setopt AUTO_CD

#--- Pipe to multiple outputs
setopt MULTIOS

#--- Spell check commands
setopt CORRECT

#--- Expand a glob
setopt GLOB_COMPLETE

#--- 10 seconds wait if you do something that will delete anything
setopt RM_STAR_WAIT

#--- use magic
setopt ZLE

setopt EXTENDED_GLOB

#--- completions
zstyle ':completion:*' menu select
zstyle ':completion::complete:*' use-cache 1
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format '%B%d%b'
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format 'No matches for: %d'
zstyle ':completion:*' list-colors "=(#b) #([0-9]*=36=31"

#-- create a zkbd compatible hash;
# to add other keys to this hash, see: man 5 terminfo
typeset -A key

key[Home]=${terminfo[khome]}
key[End]=${terminfo[kend]}
key[Insert]=${terminfo[kich1]}
key[Delete]=${terminfo[kdch1]}
key[Up]=${terminfo[kcuu1]}
key[Down]=${terminfo[kcud1]}
key[Left]=${terminfo[kcub1]}
key[Right]=${terminfo[kcuf1]}
key[PageUp]=${terminfo[kpp]}
key[PageDown]=${terminfo[knp]}

# setup key accordingly
[[ -n "${key[Home]}"    ]]  && bindkey  "${key[Home]}"    beginning-of-line
[[ -n "${key[End]}"     ]]  && bindkey  "${key[End]}"     end-of-line
[[ -n "${key[Insert]}"  ]]  && bindkey  "${key[Insert]}"  overwrite-mode
[[ -n "${key[Delete]}"  ]]  && bindkey  "${key[Delete]}"  delete-char
[[ -n "${key[Up]}"      ]]  && bindkey  "${key[Up]}"      up-line-or-history
[[ -n "${key[Down]}"    ]]  && bindkey  "${key[Down]}"    down-line-or-history
[[ -n "${key[Left]}"    ]]  && bindkey  "${key[Left]}"    backward-char
[[ -n "${key[Right]}"   ]]  && bindkey  "${key[Right]}"   forward-char

# Finally, make sure the terminal is in application mode, when zle is
# active. Only then are the values from $terminfo valid.
if (( ${+terminfo[smkx]} )) && (( ${+terminfo[rmkx]} )); then
    function zle-line-init () {
        printf '%s' "${terminfo[smkx]}"
    }
    function zle-line-finish () {
        printf '%s' "${terminfo[rmkx]}"
    }
    zle -N zle-line-init
    zle -N zle-line-finish
fi


#--- Set the prompt ----------------------------------------------------
local red_ob="%{$fg[red]%}%B[%b%{$reset_color%}"
local red_cb="%{$fg[red]%}%B]%b%{$reset_color%}"
local red_op="%{$fg[red]%}%B(%b%{$reset_color%}"
local red_cp="%{$fg[red]%}%B)%B%{$reset_color%}"
local red_l="%{$fg[red]%}%B<%b%{$reset_color%}"
local red_g="%{$fg[red]%}%B>%b%{$reset_color%}"

local p_tty="${red_ob}%{$fg[green]%}%B%l%b${red_cb}"
local p_ident="${red_ob}%{$fg[cyan]%}%B$(uname -m)/$(uname -r)%b${red_cb}"
local p_dtime="${red_op}%{$fg[cyan]%}%B%D %*%b${red_cp}"
local p_usrhost="%{$fg[blue]%}%B%n%b%{$fg[white]%}@%{$fg[green]%}%B%m%b%{$reset_color%}"
local p_path="%{$fg[yellow]%}%B%c%b%{$reset_color%}"

local p_cmd="%B%{$fg[white]%}Command%b %# %{$reset_color%}"

PROMPT="
${p_tty}${p_ident}
$(prompt_char) ${p_usrhost}--> ${p_path}
${p_cmd}"



#--- Export variables --------------------------------------------------
export JAVA_HOME=/usr/lib64/java
export JAVA_OPTS='-server -Xms512m -Xmx1024m -XX:PermSize=128m -XX:MaxPermSize=512m -XX:NewSize=192m -XX:MaxNewSize=384m -Djava.awt.headless=true -Dhttp.agent=Sakai -Dorg.apache.jasper.compiler.Parser.STRICT_QUOTE_ESCAPING=false -Dsun.lang.ClassLoader.allowArraySyntax=true'
export MAVEN_OPTS='-Xms512m -Xmx1024m -XX:PermSize=64m -XX:MaxPermSize=128m'
export NETKIT_HOME=/opt/netkit
export CUDA_HOME=/usr/local/cuda-5.0
export MONO_HOME=/usr/local
export PGSQL_HOME=/usr/local/pgsql
export ANDROID_HOME="/dvl/android"
export ANDROID_SDK="${ANDROID_HOME}/sdk"
export ANDROID_NDK="${ANDROID_HOME}/ndk"

export ANT_HOME=/opt/ant
export MAVEN_HOME=/opt/maven

export PATH="${PATH}:${JAVA_HOME}/bin:${CUDA_HOME}/bin:${JAVA_HOME}/jre/bin:${NETKIT_HOME}/bin:${ANDROID_SDK}/tools:${ANDROID_SDK}/platform-tools:${ANDROID_NDK}:${PGSQL_HOME}/bin:${ANT_HOME}/bin"
export MANPATH="${MANPATH}:${JAVA_HOME}/man:${NETKIT_HOME}/man"

export PKG_CONFIG_PATH="${MONO_HOME}/lib/pkgconfig:$PKG_CONFIG_PATH"
export LD_LIBRARY_PATH="${ANDROID_SDK}/tools/lib:${PGSQL_HOME}/lib:$LD_LIBRARY_PATH:${CUDA_HOME}/lib64:${CUDA_HOME}/lib:${MONO_HOME}/lib:/usr/local/lib64"
export DYLD_LIBRARY_FALLBACK_PATH="${MONO_HOME}/lib:${DYLD_LIBRARY_FALLBACK_PATH}"
export C_INCLUDE_PATH="${MONO_HOME}/include"
export ACLOCAL_PATH="${MONO_HOME}/share/aclocal"

#--- Aliases -----------------------------------------------------------
alias ls='ls --color=auto'
alias ll='ls -alF'
alias la='la-A'
alias l='ls -CF'
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'


#--- Extras ------------------------------------------------------------
for JNI_PATH in /usr/lib64/jni /usr/share/jni
do
	if [[ -d "$JNI_PATH" ]]; then
		if [[ -z "$LD_LIBRARY_PATH" ]]; then
			export LD_LIBRARY_PATH="$JNI_PATH"
		else
			export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$JNI_PATH"
		fi
	fi
done

export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting

source /etc/profile.d/rvm.sh
alias gdb="gdb --quiet"
