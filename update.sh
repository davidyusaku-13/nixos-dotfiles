#!/usr/bin/env bash
set -e

# Move into the directory where the script is located
cd "$(dirname "$0")"

echo "==> Pulling latest changes from Git..."
git pull

echo ""
read -p "Do you want to update flake inputs (fetch new package versions)? [y/N]: " UPDATE_FLAKE
if [[ "$UPDATE_FLAKE" =~ ^[Yy]$ ]]; then
  echo "==> Updating flake.lock..."
  nix flake update
fi

echo ""
echo "==> Rebuilding NixOS..."
sudo nixos-rebuild switch --flake .#nixos-btw

# Check if flake.lock changed during the update
if ! git diff --quiet flake.lock; then
  echo ""
  echo "==> flake.lock changed. Committing and pushing to Git..."
  git add flake.lock
  git commit -m "chore: update flake.lock dependencies"
  git push
fi

echo ""
echo "==> Cleaning up old generations (Garbage Collection)..."
# -d deletes old generations, keeping only the current running one
sudo nix-collect-garbage -d

echo ""
echo "==> Update complete!"
