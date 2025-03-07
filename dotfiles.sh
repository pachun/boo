for file in $PWD/dotfiles/*; do
  filename=$(basename "$file")
  ln -sf "$file" "$HOME/.$filename"
done

# remove infinitely recursed symlink
rm -rf $PWD/dotfiles/config/config

read -p "What name should show on your git commits? " git_name
read -p "What email should show on your git commits? " git_email

sed -i '' "s/{{GIT_NAME}}/$git_name/" "$PWD/dotfiles/gitconfig"
sed -i '' "s/{{GIT_EMAIL}}/$git_email/" "$PWD/dotfiles/gitconfig"
