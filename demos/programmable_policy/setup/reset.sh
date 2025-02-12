#!/bin/sh

script_dir="$(dirname -- "$(readlink -f -- "$0")")"

if [ -z "$script_dir" ]; then
  echo "Couldn't detect current scriptdir, exiting to prevent destructive operation"
  exit 1
fi

(
  cd "$script_dir" || exit 1
  docker compose down
  docker compose up -d
  echo "Deleting old keys"
  rm -rf "$script_dir/keys"
  "$script_dir/generate_keys.sh"
)
