<!-- !::exe -->

# Exeline

> *An exeline is like a modeline, but for executing.*

This is an useful feature I had for quite a long time, but never published
until now.  It is quite simple: it executes a command on `BufWritePost` events.
One common usage I have for this is autosourcing vimscript files:
```viml
" !::exe [so %]
" this will source the file each time it's written
``` 

### extending

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

### defaults

Exeline comes with the following defaults:
 * exe 

    which executes any vimscript inside brackets.

    e.g. `!::exe [let current = bufname('%') | call SomeFunc() | echo current . 'is being written']`

 * coffee, less, sass, jade & md

    where *argument* is a directory relative to the file's dir.
    e.g. In *file.md*, `"!::md [.]"` (or `"!::md"`) outputs `file.html` in the same dir. 

### examples

- file *hey.coffee*
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

- You could also emulate the basic functionnality of the previous 
  example like this:
  ```coffee
  # !::exe [!coffee -c %]
  ```

- file *exeline.vim*
  ```viml
  " File: exeline.vim
  " Author: romgrk
  " Description: autoexecuting code on save
  " Date: 19 Oct 2015
  " !::exe [echo bufname('%')]
  ...
  ```
  Echos buffer name
