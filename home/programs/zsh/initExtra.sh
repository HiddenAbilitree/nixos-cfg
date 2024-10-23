fastfetch
commit() {
    TYPE=$(gum choose "fix" "feat" "docs" "style" "refactor" "test" "chore" "revert")
    SCOPE=$(gum input --placeholder "scope")

    test -n "$SCOPE" && SCOPE="($SCOPE)"

    SUMMARY=$(gum input --value "$TYPE$SCOPE: " --placeholder "Summary of this change")
    DESCRIPTION=$(gum write --placeholder "Details of this change")

    gum confirm "Commit changes?" && git -C $1 commit -a -m "$SUMMARY" -m "$DESCRIPTION"
}
