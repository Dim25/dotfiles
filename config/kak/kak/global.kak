# Global settings

# Load current terminal colorscheme
colorscheme %sh{ colorscheme-switch --current }

# Show line numbers
addhl global number_lines -hlcursor -separator ' '
# highlight matching parens
addhl global show_matching
# Disable clippy
set global ui_options ncurses_assistant=none


hook global InsertChar \t %{ exec -draft -itersel h@ }
set global tabstop 4
set global indentwidth 4

hook global InsertKey <backspace> %{ try %{
    exec -draft hGh<a-k>\A\h+\Z<ret>gihyp<lt>
}}

# Tab completion
hook global InsertCompletionShow .* %{
    map window insert <tab> <c-n>
    map window insert <backtab> <c-p>
}

hook global InsertCompletionHide .* %{
    unmap window insert <tab> <c-n>
    unmap window insert <backtab> <c-p>
}

# space is my leader
map global normal <space> ':enter-user-mode user<ret>'  -docstring 'leader'
map global normal <backspace> <space> -docstring 'remove all sels except main'
map global normal <a-backspace> <a-space> -docstring 'remove main sel'
unmap global normal ,

map -docstring "Open shell" global user <ret> ':repl<ret>'

# For some reason the first call to this is mixed with the actual user mode
declare-user-mode noThankYou

# Tab through search results
def tabsearch -params 1 %{
    define-command -allow-override next "exec \"%arg{1}\%reg{/}\""
    map global prompt <tab> <ret>:next<ret>
    exec %arg{1}
}

def colon %{
    map global prompt <tab> <tab>
    exec :
}

map global normal / ':tabsearch /<ret>' -docstring "Search"
map global normal ? ':tabsearch ?<ret>' -docstring "Search (extend)"
map global normal <a-/> ':tabsearch <lt>a-/><ret>' -docstring "Search backwards"
map global normal <a-?> ':tabsearch <lt>a-?><ret>' -docstring "Search backwards (extend)"
map global normal : :colon<ret> -docstring "Run command"

# Filetype mode

hook global BufSetOption filetype=.* %{
    try %{ declare-user-mode filetype }
}

map global normal , ':enter-user-mode filetype<ret>'
