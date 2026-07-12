#!/usr/bin/env bash
set -e

# Move into the directory where the script is located
cd "$(dirname "$0")"


# Fallback in case 'gum' isn't in PATH yet (e.g., first run before rebuilding)
GUM=$(command -v gum || echo "nix run nixpkgs#gum --")

$GUM style --foreground 212 --border-foreground 212 --border double --align center --width 50 --margin "1 2" --padding "1 2" "NixOS Updater"

$GUM style --foreground 99 "🔄 Pulling latest changes from Git..."
git pull
echo ""

if $GUM confirm "Update flake inputs (fetch new package versions)?"; then
  echo ""
  $GUM spin --spinner dot --title "Updating flake.lock..." -- nix flake update
fi

echo ""
$GUM style --foreground 82 "🚀 Rebuilding NixOS..."
sudo nixos-rebuild switch --flake .#nixos-btw

# Check if flake.lock changed during the update
if ! git diff --quiet flake.lock; then
  echo ""
  $GUM style --foreground 220 "📦 flake.lock changed. Committing and pushing..."
  git add flake.lock
  git commit -m "chore: update flake.lock dependencies"
  git push
fi

echo ""
$GUM style --foreground 196 "🗑️ Cleaning up old generations (Garbage Collection)..."
sudo nix-collect-garbage -d

echo ""
$GUM style --foreground 46 "✨ Update complete!"
