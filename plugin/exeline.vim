" File: exeline.vim
" Author: romgrk
" Description: Execute line for certain filetypes
" Last Modified: October 16, 2014
" !::exe [echo "NOT AUTOSOURCED"]

augroup Exeline
    au!
    au BufWritePost * call exeline#find()
augroup END



