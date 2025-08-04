let carapace_completer = {|spans|carapace $spans 0nushell
...$spans | from json
}

$env.config.completions.external.completer = $carapace_completer

mkdir ($nu.data-dir | path join "vendor/autoload")
starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")

def xvim [path?: string] {
  let curdir = (pwd)
  if ($path | is-empty) {
    ^nvim
  } else {
      try {
        cd $path
        ^nvim $path
      }
    }
  cd $curdir
}

# $env.config = (
#     $env.config | upsert keybindings (
#         $env.config.keybindings
#         | append {
#             name: atuin
#             modifier: none
#             keycode: up
#             mode: [emacs, vi_normal, vi_insert]
#             event: {
#                 until: [
#                     {send: menuup}
#                     {send: executehostcommand cmd: (_atuin_search_cmd '--shell-up-key-binding') }
#                 ]
#             }
#         }
#     )
# )
