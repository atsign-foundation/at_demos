#!/bin/bash

script_dir="$(dirname -- "$(readlink -f -- "$0")")"

dirs=(atkeys cram_key_qrcodes pkam_key_qrcodes)

if [ $(uname) = 'Darwin' ]; then
  echo using gnu grep
  _grep='ggrep' # macos grep alias doesn't support -P so use gnu grep from homebrew
else
  _grep='grep'
fi

# the normalized hammer and wrench emoji is u1 followed by u2
# unicode codepoints for grep
u1='1F6E0' # hammer and wrench emoji
u2='FE0F'  # variant selector

# utf8 mappings for sed
x1='\xf0\x9f\x9b\xa0' # hammer and wrench emoji
x2='\xef\xb8\x8f'     # variant selector

for d in ${dirs[@]}; do
  echo normalizing emojis in $d

  # This explicitly only targets files where the variant selector DOESNT follow the hammer and wrench
  # So we will never get something like $u1$u1$u1$u2 caused by extra runs
  files=$(ls "$script_dir/$d" | $_grep -P "[\x{$u1}][^\x{$u2}]")
  # echo $files

  for f in ${files}; do
    # Additional guard against creating $u1$u1$u2 situation
    if echo $f | $_grep -q -P "[\x{$u1}][\x{$u2}]"; then
      echo "detected $f which possibly contains multiple unicode codepoints... skipping"
    else
      # one more check because I'm paranoid
      if echo $f | sed -e "s/$x1/$x1$x2/g" | $_grep -q -P "[\x{$u1}][\x{$u2}]"; then
        new_name=$(echo $f | sed -e "s/$x1/$x1$x2/g")
        if echo $f | $_grep -q -P '[^_key].atKeys$'; then
          echo 'adding _key'
          new_name=$(echo $new_name | sed -e 's/.atKeys/_key.atKeys/g')
          echo $new_name
        fi
        mv "$script_dir/$d/$f" "$script_dir/$d/$new_name"
      fi
    fi
  done

  files=$(ls "$script_dir/$d" | $_grep -P "[\x{$u1}][^\x{$u2}]")
  echo "files which failed to convert: $files"
done
