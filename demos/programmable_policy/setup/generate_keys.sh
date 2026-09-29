#!/usr/bin/env bash

script_dir="$(dirname -- "$(readlink -f -- "$0")")"

skipped=$((0))
total=$((0))
failed=$((0))
generate_key() {
  ATSIGN="$1"
  CRAM="$3"

  if ! [ -f "$script_dir/keys/@${ATSIGN}_key.atKeys" ]; then
    at_activate onboard \
      -a "@$ATSIGN" \
      -c "$CRAM" \
      -r "vip.ve.atsign.zone" \
      -k "$script_dir/keys/@${ATSIGN}_key.atKeys" 2>/dev/null >/dev/null &&
      echo "Successfully activated $ATSIGN" ||
      {
        echo "Failed to create atKeys for $ATSIGN"
        exit 1
      }
    exit 0
  else
    echo "Skipped $ATSIGN, keys already exist"
    exit 2
  fi
}

mkdir "$script_dir/keys"
pids=()
cancel() {
  for pid in "${pids[@]}"; do
    kill -s SIGINT "$pid"
  done
  echo "All key generations cancelled"
  exit 0
}
trap cancel SIGINT

echo "Queuing up all activations"
while read -r line; do
  generate_key $line & # intentional word splitting
  pids[total]=$! &&
    total=$((total + 1))
done <"$script_dir/setup_mount/atservers"

echo "Waiting for all activations to complete"
for pid in "${pids[@]}"; do
  wait "$pid"
  case "$?" in
  1) failed=$((failed + 1)) ;;
  2) skipped=$((skipped + 1)) ;;
  esac
done

if [ $skipped -gt 0 ]; then
  echo "[WARN]  $skipped/$total activations skipped"
fi

if [ $failed -gt 0 ]; then
  echo "[ERROR] $failed/$total activations failed"
else
  echo All attempted activations succeeded
fi
