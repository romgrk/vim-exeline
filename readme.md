<!-- !::exe [echo bufname('%')] -->

# Vim-Exeline

This is an useful feature I had for quite a long time, but never published.
It is quite simple: it executes a given script on `BufWritePost` events.
It can execute different types of script depending on the file.

E.g.: inserting `!::exe [EXPR]` executes EXPR each time the file is saved.

One common usage I have for this is vim settings file. I autoreload them
by having `" !::exe [so %]` at the top of the file.

### Examples

exeline.vim
```viml
" File: exeline.vim
" Author: romgrk
" Description: autoexecuting code on save
" Date: 19 Oct 2015
" !::exe [echo bufname('%')]
```
Echos buffer name

file.coffee
```coffee
# !::coffee [.]

func = ->
  console.log 'Hey!'
func()
```
Outputs file.js

