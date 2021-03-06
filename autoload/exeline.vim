" File: exeline.vim
" Author: romgrk
" Description: autoexecuting code on save
" Date: 19 Oct 2015
" !::exe [echo 'NOT AUTOSOURCED']

let s:cmd = 0
let s:args = 0
let s:current_buffer = 0

function! exeline#onBufWritePre ()
    let s:current_buffer = bufnr('%')
endfu

function! exeline#onBufWritePost ()
    call exeline#find()
endfu

function! exeline#callback(timer)
    try
        if exists('*exeline#' . s:cmd)
            call call('exeline#' . s:cmd, [s:args])
        elseif exists('g:exeline[s:cmd]')
            call g:exeline[s:cmd](s:args)
        end
    catch /.*/
        echohl ErrorMsg
        echo 'Exeline: ' . v:exception . '; Cmd: ' . s:cmd
        echohl None
    endtry
endfu

function! exeline#find () " {{{1
python << endpython
import vim, sys, re

nr = int(vim.eval('s:current_buffer'))
currentBuffer = vim.buffers[nr]

try:
    head = "\n".join(currentBuffer[:10])
    head += "\n".join(currentBuffer[-5:-1])
except Error:
    vim.command('return')

pattern = re.compile("!::(?P<cmd>[\w]+)\s*((\[(?P<args>([^\]]|(?<=\\\\)\])+)\])|(?P<json>[{].*[}]\!))?", re.X | re.M | re.S)
match = pattern.search(head)

if match:
    #print match.group(0)
    cmd, args, json = match.group('cmd', 'args', 'json')
    vim.command("let s:cmd = '%s'" % cmd )
    if args:
        args = args.replace('\'', '\'\'')
        vim.command("let s:args = '" + args + "'")
    elif json:
        json = json.replace('\'', '\'\'')
        json = json.replace("}"+"!", "}")
        vim.command("let s:args = '%s'" % json)
    else:
        vim.command("let s:args = ''")
else:
    # print currentBuffer.name
    vim.command('let s:cmd = 0')
    vim.command('return')
endpython

    let timer = timer_start(10, 'exeline#callback')
endfunction " 1}}}

function! s:pcall(fx, arguments)
    let d={}
    let d.Fx=function(a:fx)
    execute "try"
       \."\n   call call(a:fx, a:arguments, {})"
       \."\n   let r=0"
       \."\n catch /.*/"
       \."\n   let r=1"
       \."\n endtry"
    return r
endfunction

function! exeline#exe (expression) " {{{1
    execute a:expression
endfunction " 1}}}

function! exeline#md (expression) " {{{1
    let htmlfile = resolve(expand('%:p:h') . '/' . a:expression . '/' . expand('%:t:r') . '.html')
    silent! exe ':silent !markdown % >' . htmlfile
    echo "Compiled to " . htmlfile
endfunction " 1}}}

function! exeline#coffee (expression) " {{{1
    let options = split(a:expression, ',')
    let dir = resolve(expand('%:p:h') . '/' . options[0])
    let flags = '-c '
    let flags .= '-o ' . dir
    if exists("options[1]")
        let flags .= ' ' . options[1] . ' '
    endif
    let result = split(system('coffee ' . flags . ' ' . expand('%')), "\\n")
    if len(result) != 0
        let matches = matchlist(result[0], "\\v([0-9]+):([0-9]+): (.+)")
        echohl ErrorMsg
        echo matches[3]
        echohl Normal
        exe ':match Error /\v%' . matches[1] . 'l.+/'
        call cursor(matches[1], matches[2])
    else
        exe ':match Error //'
        echo "Compiled to " . dir . "/" . expand("%:t:r") . '.js'
    endif
endfunction " 1}}}

function! exeline#less (expression) " {{{1
    if (a:expression != '')
        let dir = resolve(expand('%:p:h') . '/' . a:expression)
        exe ':!lessc ' . expand('%') . ' > ' . dir . '/' . expand("%:t:r") . '.css'
    else
        exe ':!lessc ' . expand("%") . ' > ' . expand("%:r") . '.css'
    endif
endfunction " 1}}}

function! exeline#sass (expression) " {{{1
    let dir = resolve(expand('%:p:h') . '/' . a:expression)
    let out = dir . '/' . expand("%:t:r") . '.css'
    let result = split(system('sass ' . expand('%')), "\\n")
    if match(result[0], "^Error") != -1
        "echo result
        let message = result[0]
        echo message
        let lnum = matchlist(result[1], "\\von line ([0-9]+)")[1]
        call cursor(lnum, 0)
    else
        call writefile(result, out)
        echo "Compiled to " . out
    endif
endfunction " 1}}}

function! exeline#jade (expression) " {{{1
    let dir = resolve(expand('%:p:h') . '/' . a:expression)
    let out = dir . "/" . expand("%:t:r") . '.html'
    let result = split(system('jade -o ' . dir . ' ' . expand('%') ), "\\n")
    let matches = matchlist(result, '\v\> ([0-9]+)\|')
    if len(matches) != 0
        "echo matches
        "echo result
        echohl Error
        echo "Error at line " . matches[1]
        echohl Normal
        call cursor(matches[1], 0)
    else
        "exe ':match Error //'
        echohl DiffAdd
        echo "Compiled to " . out
        echohl Normal
    endif
endfunction " 1}}}
