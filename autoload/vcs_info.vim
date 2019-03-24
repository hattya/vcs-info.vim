" File:        autoload/vcs_info.vim
" Author:      Akinori Hattori <hattya@gmail.com>
" Last Change: 2019-03-24
" License:     MIT License

let s:save_cpo = &cpo
set cpo&vim

let s:L = vital#vcs_info#import('Data.List')
let s:V = vital#vcs_info#import('Prelude')
let s:P = vital#vcs_info#import('Process')
let s:FP = vital#vcs_info#import('System.Filepath')

let s:vcses = []

function! vcs_info#detect(path) abort
  unlet! b:vcs_info
  let path = a:path !=# '' && !isdirectory(a:path) ? s:FP.dirname(a:path) : a:path
  let prev = ''
  while path !=# prev
    for vcs in s:vcses
      let dir = vcs_info#{vcs}#detect(path)
      if dir !=# ''
        let b:vcs_info = {
        \  'vcs': vcs,
        \  'dir': dir,
        \}
        return
      endif
    endfor
    let prev = path
    let path = s:FP.dirname(path)
  endwhile
endfunction

function! vcs_info#get() abort
  return exists('b:vcs_info') ? vcs_info#{b:vcs_info.vcs}#get(b:vcs_info.dir) : {}
endfunction

function! vcs_info#abbr(hash) abort
  let n = s:getvar('vcs_info_abbr', 7)
  return n > 0 ? a:hash[: n-1] : ''
endfunction

function! vcs_info#all(path, args) abort
  return isdirectory(a:path) && len(filter(copy(a:args), 'getftype(s:FP.join(a:path, v:val)) !=# ""')) == len(a:args)
endfunction

function! vcs_info#any(path, args) abort
  return isdirectory(a:path) && len(filter(copy(a:args), 'getftype(s:FP.join(a:path, v:val)) !=# ""')) > 0
endfunction

function! vcs_info#from_slash(path) abort
  return s:V.is_windows() ? tr(a:path, '/', '\') : a:path
endfunction

function! vcs_info#readfile(name) abort
  return filereadable(a:name) ? join(readfile(a:name), "\n") : ''
endfunction

function! vcs_info#reload() abort
  let s:vcses = []
  for f in s:V.globpath(&runtimepath, s:FP.join('autoload', 'vcs_info', '*.vim'))
    call add(s:vcses, fnamemodify(f, ':t:r'))
  endfor
  call s:L.uniq(s:vcses)
endfunction

function! vcs_info#to_slash(path) abort
  return s:V.is_windows() ? tr(a:path, '\', '/') : a:path
endfunction

function! vcs_info#system(args, ...) abort
  let environ = {
  \  'LANGUAGE': [$LANGUAGE, 'C'],
  \}
  let restore = 0
  try
    let args = a:args
    if &shell =~? 'sh$'
      let env = ['env']
      for [k, v] in items(environ)
        call add(env, k . '=' . v[1])
      endfor
      let args = s:V.is_list(args) ? extend(env, args) : join(add(env, args), ' ')
    elseif s:V.is_windows()
      for [k, v] in items(environ)
        execute printf("let $%s = '%s'", k, v[1])
      endfor
      let restore = 1
    endif
    silent let out = call(s:P.system, [args] + a:000)
  finally
    if restore
      for [k, v] in items(environ)
        execute printf("let $%s = '%s'", k, v[0])
      endfor
    endif
  endtry
  return s:P.get_last_status() ? [] : split(out, '\n')
endfunction

function! s:getvar(name, ...) abort
  return get(b:, a:name, get(g:, a:name, a:0 > 0 ? a:1 : 0))
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
