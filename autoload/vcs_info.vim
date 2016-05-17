" File:        autoload/vcs_info.vim
" Author:      Akinori Hattori <hattya@gmail.com>
" Last Change: 2016-05-17
" License:     MIT License

let s:save_cpo = &cpo
set cpo&vim

let s:L = vital#vcs_info#import('Data.List')
let s:V = vital#vcs_info#import('Prelude')
let s:FP = vital#vcs_info#import('System.Filepath')

let s:vcses = []

function! vcs_info#detect(path) abort
  unlet! b:vcs_info
  let path = a:path
  if path !=# '' && !isdirectory(path)
    let path = s:FP.dirname(path)
  endif
  let prev = ''
  while path !=# prev
    for vcs in s:vcses
      let dir = call('vcs_info#' . vcs . '#detect', [path])
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
  if !exists('b:vcs_info')
    return {}
  endif
  return call('vcs_info#' . b:vcs_info.vcs . '#get', [b:vcs_info.dir])
endfunction

function! vcs_info#abbr(hash) abort
  let n = get(b:, 'vcs_info_abbr', get(g:, 'vcs_info_abbr', 7))
  return 0 < n ? a:hash[: n - 1] : ''
endfunction

function! vcs_info#from_slash(path) abort
  return s:V.is_windows() ? substitute(a:path, '/', '\', 'g') : a:path
endfunction

function! vcs_info#reload() abort
  let s:vcses = []
  for f in s:V.globpath(&runtimepath, s:FP.join('autoload', 'vcs_info', '*.vim'))
    call add(s:vcses, fnamemodify(f, ':t:r'))
  endfor
  call s:L.uniq(sort(s:vcses))
endfunction

function! vcs_info#to_slash(path) abort
  return s:V.is_windows() ? substitute(a:path, '\\', '/', 'g') : a:path
endfunction

call vcs_info#reload()

let &cpo = s:save_cpo
unlet s:save_cpo
