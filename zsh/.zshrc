####
#--- LOAD SETTINGS -----------------------------------------------------
autoload -U compinit
autoload -U promptinit
autoload -U colors && colors
autoload -U zsh-mime-setup
autoload -U zcalc
#--- End of Load Settings ----------------------------------------------
####


####
#--- EXPORT VARIABLES --------------------------------------------------
#--- Applications Home
export JAVA_HOME="/usr/lib64/java"
export JAVA_OPTS='-server -Xms512m -Xmx1024m -XX:PermSize=128m -XX:MaxPermSize=512m -XX:NewSize=192m -XX:MaxNewSize=384m -Djava.awt.headless=true -Dhttp.agent=Sakai -Dorg.apache.jasper.compiler.Parser.STRICT_QUOTE_ESCAPING=false -Dsun.lang.ClassLoader.allowArraySyntax=true'
export MAVEN_OPTS='-Xms512m -Xmx1024m -XX:PermSize=64m -XX:MaxPermSize=128m'
export NETKIT_HOME="/opt/netkit"
export CUDA_HOME="/usr/local/cuda-5.0"
export MONO_HOME=/usr/local
export PGSQL_HOME="/usr/local/pgsql"
export ANDROID_HOME="/dvl/android"
export ANDROID_SDK="${ANDROID_HOME}/sdk"
export ANDROID_NDK="${ANDROID_HOME}/ndk"
export ANT_HOME="/opt/ant"
export MAVEN_HOME="/opt/maven"
#--- Path Modification
export PATH="${PATH}:${JAVA_HOME}/bin:${CUDA_HOME}/bin:${JAVA_HOME}/jre/bin:${NETKIT_HOME}/bin:${ANDROID_SDK}/tools:${ANDROID_SDK}/platform-tools:${ANDROID_NDK}:${PGSQL_HOME}/bin:${ANT_HOME}/bin"
export MANPATH="${MANPATH}:${JAVA_HOME}/man:${NETKIT_HOME}/man"
export PKG_CONFIG_PATH="${MONO_HOME}/lib/pkgconfig:$PKG_CONFIG_PATH"
export LD_LIBRARY_PATH="${ANDROID_SDK}/tools/lib:${PGSQL_HOME}/lib:$LD_LIBRARY_PATH:${CUDA_HOME}/lib64:${CUDA_HOME}/lib:${MONO_HOME}/lib:/usr/local/lib64"
export DYLD_LIBRARY_FALLBACK_PATH="${MONO_HOME}/lib:${DYLD_LIBRARY_FALLBACK_PATH}"
export C_INCLUDE_PATH="${MONO_HOME}/include"
export ACLOCAL_PATH="${MONO_HOME}/share/aclocal"
#--- End of Export Variables -------------------------------------------
####


####
#--- ALIASES -----------------------------------------------------------
alias gdb="gdb --quiet"
alias ls='ls --color=auto'
alias ll='ls -alF'
alias la='la-A'
alias l='ls -CF'
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
alias r2d="r2 -d"
#--- End of aliases ----------------------------------------------------
####


####
#--- FUNCTIONS ---------------------------------------------------------
function prompt_char {
    git branch >/dev/null 2>/dev/null && echo '±' && return
    hg root >/dev/null 2>/dev/null && echo '☿' && return
    echo '○'
}
function detectuptime {
    echo $(uptime | awk '{$1=$2=$(NF-6)=$(NF-5)=$(NF-4)=$(NF-3)=$(NF-2)=$(NF-1)=$NF=""; sub(" days","d");sub(",","");sub(":","h ");sub(",","m"); print}')
}
function detectshell {
    echo $(echo "$SHELL" | awk -F'/' '{print $NF}')
}
function detectres {
    echo $(xdpyinfo | sed -n 's/.*dim.* \([0-9]*x[0-9]*\) .*/\1/pg' | tr '\n' ' ')
}
function detectcpu {
    cpu=$(awk 'BEGIN{FS=":"} /model name/ { print $2; exit }' /proc/cpuinfo | sed 's/ @/\n/' | head -1)
    cpu=$(sed $REGEXP 's/\([tT][mM]\)|\([Rr]\)|[pP]rocessor//g' <<< "${cpu}" | xargs)
    echo ${cpu}
}
function detectmem {
    human=1024

    mem_info=$(egrep 'Mem|Cache|Buffers' /proc/meminfo)
    mem_info=$(echo $(echo $(mem_info=${mem_info// /}; echo ${mem_info//kB/})))
    
    m=$(echo $mem_info | awk '{ print $1 }')
    memtotal=${m//*:}
    m=$(echo $mem_info | awk '{ print $2 }')
    memfree=${m//*:}
    m=$(echo $mem_info | awk '{ print $3 }')
    membuffer=${m//*:}
    m=$(echo $mem_info | awk '{ print $4 }')
    memcached=${m//*:}

    usedmem="$(( ($memtotal - $memfree - $membuffer - $memcached) / $human ))"
    totalmem="$(($memtotal / $human))"

    echo "${usedmem}MB / ${totalmem}MB"
}
function detectcore {
    loc="/sys/devices/system/cpu/cpu${1}/cpufreq"
    cpu_mhz=$(awk '{print $1/1000}' "${loc}/bios_limit")
    echo "${cpu_mhz} MHz"
}
#--- End of functions --------------------------------------------------
####


####
#--- OPTIONS -----------------------------------------------------------
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
setopt EXTENDED_GLOB
#--- 10 seconds wait if you do something that will delete anything
setopt RM_STAR_WAIT
#--- use magic
setopt ZLE
#--- completions
zstyle ':completion:*' menu select
zstyle ':completion::complete:*' use-cache 1
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format '%B%d%b'
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format 'No matches for: %d'
zstyle ':completion:*' list-colors "=(#b) #([0-9]*=36=31"
#--- create a zkbd compatible hash;
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
#--- End of Options ----------------------------------------------------
####


#### 
#--- PROMPT ------------------------------------------------------------
#--- Base Colors
# Add another by RGB color number, such as %{$fg[number]%}
# Prompt
local clreset="%{$reset_color%}"
local clred="%{$fg[red]%}"
local clblue="%{$fg[blue]%}"
local clgreen="%{$fg[green]%}"
local clcyan="%{$fg[cyan]%}"
local clyellow="%{$fg[yellow]%}"
local clwhite="%{$fg[white]%}"
# General Purpose
local br=${fg_bold[red]}
local bb=${fg_bold[blue]}
local bbg=${fg_bold[green]}
local by=${fg_bold[yellow]}
#--- Characters
local red_ob="${clred}%B[%b${reset}"
local red_cb="${clred}%B]%b${reset}"
local red_op="${clred}%B(%b${reset}"
local red_cp="${clred}%B)%b${reset}"
local red_lt="${clred}%B<%b${reset}"
local red_gt="${clred}%B>%b${reset}"
#--- Colors
#local red_ob="%{$fg[red]%}%B[%b%{$reset_color%}"
#local red_cb="%{$fg[red]%}%B]%b%{$reset_color%}"
#local red_op="%{$fg[red]%}%B(%b%{$reset_color%}"
#local red_cp="%{$fg[red]%}%B)%B%{$reset_color%}"
#local red_l="%{$fg[red]%}%B<%b%{$reset_color%}"
#local red_g="%{$fg[red]%}%B>%b%{$reset_color%}"
#--- Definitions
local p_tty="${red_ob}${clgreen}%B%l%b${red_cb}"
local p_ident="${red_ob}${clcyan}%B$(uname -m)/$(uname -r)%b${red_cb}"
local p_dtime="${red_op}${clcyan}%B%D %*%b${red_cp}"
local p_usrhost="${clblue}%B%n%b${clwhite}@${clgreen}%B%m%b${clreset}"
local p_path="${clyellow}%B%c%b${clreset}"
local p_cmd="%B${clwhite}Command%b %# ${clreset}"
#--- Logo and Introduction
echo "                   ${by}~                      "
echo "                ,+++++,                   "
echo "+            ++    +    ++            +   "
echo " +++=      ${bb}=     ${by}~:~:~     ${bb}=      ${by}:+++    "
echo "  ++:+++ ${bb}= =  ${by}==II+++II==  ${bb}= = ${by}+++,++     ${fg_bold[blue]}Operating System:${reset_color} GUNDAM PhalconOS"
echo "    ${by}+:+++~++=??~:+++++=~I?=++=+++:+       ${fg_bold[blue]}Uptime:${reset_color} $(detectuptime)"
echo "     ${by}+,++++++=++=+++++=++=++++++,+        ${fg_bold[blue]}Shell:${reset_color} $(detectshell)"
echo "       ${by}:+++++++++:+++:+++++++++:          ${fg_bold[blue]}Resolution:${reset_color} $(detectres)"
echo "        ${by}++++++++++++++++++++++=           ${fg_bold[blue]}CPU:${reset_color} $(detectcpu)"
echo "       ${bb}= ==I:~${by}+++++++++++${bb}::I=~ =          ${fg_bold[blue]}RAM:${reset_color} $(detectmem)"
echo "        ${bb}= =I+==:::${by}+++${bb}=~:::+I= =           "
echo "       ${bb}~== =+~==:${by}+++++${bb}=::,?= ==~          "
echo "         ${bb}=  =I7::${by}+++++${bb}=:+I=  =            ${fg_bold[blue]}OctoEngine Initialized...${reset_color} OK "
echo "         ${bb}=== ==+I,${by}+++${bb},I?7= ===            ${fg_bold[blue]}    Core 1:${reset_color} ${fg_bold[green]}UP ${fg[red]}$(detectcore 0)${reset_color}"
echo "           ${bb}~=  ==~${by}+++${bb}~==  =~              ${fg_bold[blue]}    Core 2:${reset_color} ${fg_bold[green]}UP ${fg[red]}$(detectcore 1)${reset_color}"
echo "            ${bb},===:  ${by}+  ${bb}:===,               ${fg_bold[blue]}    Core 3:${reset_color} ${fg_bold[green]}UP ${fg[red]}$(detectcore 2)${reset_color}"
echo "              ${bb}=====${by}+${bb}====+                 ${fg_bold[blue]}    Core 4:${reset_color} ${fg_bold[green]}UP ${fg[red]}$(detectcore 3)${reset_color}"
echo "                ${bb},  ${by}+  ${bb},                   ${fg_bold[blue]}    Core 5:${reset_color} ${fg_bold[green]}UP ${fg[red]}$(detectcore 4)${reset_color}"
echo "                   ${by}+                      ${fg_bold[blue]}    Core 6:${reset_color} ${fg_bold[green]}UP ${fg[red]}$(detectcore 5)${reset_color}"
echo "                   ${by}+                      ${fg_bold[blue]}    Core 7:${reset_color} ${fg_bold[green]}UP ${fg[red]}$(detectcore 6)${reset_color}"
echo " ${br}Fiat Justitia     ${by}+                      ${fg_bold[blue]}    Core 8:${reset_color} ${fg_bold[green]}UP ${fg[red]}$(detectcore 7)${reset_color}"
echo " ${br}Ruat Caelum       ${by}=                      "
echo "                   ${by}:                      "
echo "                                               "
#--- Set prompts
PROMPT="
${p_tty}${p_ident}
☿ ${p_usrhost}--> ${p_path}
${p_cmd}"
#--- End of Prompt -----------------------------------------------------
####


####
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
#--- End of Extras -----------------------------------------------------
####