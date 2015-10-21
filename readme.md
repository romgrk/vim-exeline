<!-- !::exe -->

## vim-exeline

This is an useful feature I had for quite a long time, but never published.
It is quite simple: it executes a command on `BufWritePost` events.
It can execute different types of commands.

One common usage I have for this is vim settings file. I autoreload them
by having 
```viml
" !::exe [so %]
``` 
at the top of the file.

You can extend it by defining a function like this:
```viml
function! exeline#foo (expression)
  echo a:expression
endfunction
```
Thus, having `!::foo [bar]` would echo `bar`.

Exeline comes with these defaults:
 * !::exe *[EXPRESSION]*
 * !::coffee *[DIR]*
 * !::less *[DIR]*
 * !::sass *[DIR]*
 * !::jade *[DIR]*
 * !::md *[DIR]*

Where *DIR* is a [relative] directory.
E.g. In *file.md*:
`!::md [.]` outputs `file.html` in the same dir. 
As `!::md` does.

### Examples

file.coffee
```coffee
# !::coffee [.]

func = ->
  console.log 'Hey!'
func()
```
Outputs file.js
**NOTE:** `coffee` is actually quite advanced

exeline.vim
```viml
" File: exeline.vim
" Author: romgrk
" Description: autoexecuting code on save
" Date: 19 Oct 2015
" !::exe [echo bufname('%')]
```
Echos buffer name
