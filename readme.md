<!-- !::exe -->

## vim-exeline

This is an useful feature I had for quite a long time, but never published.
It is quite simple: it executes a command on `BufWritePost` events.
One common usage I have for this is vim settings file. I autoreload them
by having 
```viml
" !::exe [so %]
``` 
at the top of the file.

You can extend it by defining a function like this:
```viml
let exeline = {}
function! exeline.foo (expression)
    echo a:expression
endfunction
```
Thus, having `!::foo [bar]` would echo `bar`.

The following also works, but it has to be placed in a file named *exeline.vim*.
```viml
function! exeline#foo (expression)
    echo a:expression
endfunction
```
Exeline comes with these defaults:
 * exe, which executes any vimscript inside brackets
 * coffee, less, sass, jade & md
    where *argument* is a directory relative to the file's dir.
    E.g. 
      In *file.md*, `"!::md [.]"` (or `"!::md"`) outputs `file.html` in the same dir. 

### Examples

file.coffee
```coffee
# !::coffee [.]

func = ->
  console.log 'Hey!'
func()
```
Outputs file.js

**NOTE:** `coffee` is actually quite advanced. If there is an error,
it will highlight the line with `Error`, jump to it, and print the
error message returned by `coffee`.

You could also emulate this by having:

```coffee
# !::exe [!coffee -c %]
```

exeline.vim
```viml
" File: exeline.vim
" Author: romgrk
" Description: autoexecuting code on save
" Date: 19 Oct 2015
" !::exe [echo bufname('%')]
```
Echos buffer name
