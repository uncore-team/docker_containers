# ~/.bashrc: Configuración de inicialización para sesiones de shell interactivo

# Si no es una sesión interactiva, salir
[ -z "$PS1" ] && return

# Historial
HISTCONTROL=ignoredups:erasedups    # No duplicar entradas en el historial
HISTSIZE=1000                       # Número de comandos a mantener en el historial
HISTFILESIZE=2000                   # Tamaño máximo del archivo de historial
shopt -s histappend                 # Agregar al historial, no sobrescribirlo

# Colores para el prompt y los comandos
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# Aliases comunes
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Prompt personalizado (con colores)
PS1='\[\e[0;32m\]\u@\h \[\e[0;34m\]\w\[\e[0m\] \$ '

# Configuración de PATH
export PATH="$HOME/bin:$PATH"

# Autocompletado (asegúrate de que bash-completion está instalado)
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
elif [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
fi

# Opciones del shell
shopt -s checkwinsize                # Ajustar el tamaño de la ventana automáticamente
shopt -s globstar                    # Habilitar '**' para hacer coincidir directorios recursivamente

# Variables de entorno personalizadas
export EDITOR=nano                    # Editor por defecto
export VISUAL=nano
export PAGER=less                     # Paginador por defecto
export NO_AT_BRIDGE=1

#export DISPLAY=localhost:10.0

# Función útil para buscar en el historial
histgrep() {
    history | grep "$1"
}
