## 2.0.0
- BREAKING CHANGE: replaced unicode U+1F6E0 with U+1F6E0 U+FE0F for all
  :hammer_and_wrench: emojis  
  (normalized the emojis by adding the variant selector)

- The reason for making this change is that shells (e.g. bash, zsh) and emoji 
  normalization techniques expect the variant selector to be there. Specifically
  with the :hammer_and_wrench: emoji. Most shells recognize the U+1F6E0
  character as a double wide character which takes up a single column. The 
  U+FE0F is a zero-width character which also takes up a single column. Thus
  correcting the number of columns to match the width of the characters. Without
  this normalization, it becomes difficult to use the characters over the shell.

## 1.0.3
- **Fix**: Fixed duplicate cram keys for apkam atsigns
## 1.0.2
- **Feat**: Added demo atsigns for apkam
## 1.0.1
- **Feat**: Added demo credentials for apkam symmetric key
- **Chore**: Updated documentation.
- **Feat**: Added atkey files for demo atsigns.

## 1.0.0
- **BREAKING CHANGE**: Support for sound null-safety.
- **Feat**: Re-arranged all the Keys according to the user's names in classes.

## 0.0.3+1
- **Feat**: Added aesKeyMap.

## 0.0.2+1
- **Chore**: Ensure example gets found by pub.dev.

## 0.0.2
- **Chore**: Matching up versions in the docs.

## 0.0.1
- Initial release.
