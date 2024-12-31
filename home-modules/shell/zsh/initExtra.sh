commit() {
  TYPE=$(gum choose "fix" "feat" "docs" "style" "refactor" "test" "chore" "revert")
  SCOPE=$(gum input --placeholder "scope")

  test -n "$SCOPE" && SCOPE="($SCOPE)"

  SUMMARY=$(gum input --value "$TYPE$SCOPE: " --placeholder "Summary of this change")
  DESCRIPTION=$(gum write --placeholder "Details of this change")

  gum confirm "Commit changes?" && git -C "$1" commit -a -m "$SUMMARY" -m "$DESCRIPTION"
}

disassemble() {
  if ! command -v objdump '{ cmd > file; } 2>&1' >/dev/null; then
    echo "objdump could not be found"
  else
    if [ -z "$1" ]; then
      echo Pick a file to disassemble:
      FILE=$(gum file ./ --height 5)
    else
      FILE=$1
    fi
    if gum confirm "Select symbols?"; then
      if ! command -v nm '{ cmd > file; } 2>&1' >/dev/null; then
        echo "nm could not be found"
      else
        objdump -rwC --visualize-jumps=color --no-show-raw-insn -Matt --disassembler-color=on --show-all-symbols --file-headers --disassemble=$(nm -gjUWC "$FILE" | gum filter --height 5 --placeholder "Pick a symbol...") "$FILE"
      fi
    else
      objdump -rwCd --visualize-jumps=color --no-show-raw-insn -Matt --disassembler-color=on --show-all-symbols --file-headers "$FILE"
    fi
  fi
}

xvim() {
  curdir=$(pwd) && [ -z "$1" ] && nvim || cd "$1" && nvim "$1" && trap 'cd "$curdir" || return' EXIT
}

tre() {
  if [ -z ${1+x} ]; then
    eza --icons=always -T
  else eza --icons=always -T -L "$1"; fi
}

nix-init() {
  if [ -z "$1" ]; then
    echo Please specify a flake template.
  else
    nix flake init --refresh --template "github:HiddenAbilitree/flake-templates#$1" && direnv-init
  fi
}
direnv-init() {
  echo "use flake" >>.envrc && direnv allow
}
eval "$(atuin init zsh --disable-up-arrow)"
eval "$(direnv hook zsh)"
