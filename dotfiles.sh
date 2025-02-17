for file in $PWD/dotfiles/*; do
  filename=$(basename "$file")
  ln -sf "$file" "$HOME/.$filename"
done
