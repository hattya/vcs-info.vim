" File:        autoload/vcs_info/cvs.vim
" Author:      Akinori Hattori <hattya@gmail.com>
" Last Change: 2016-01-03
" License:     MIT License

let s:save_cpo = &cpo
set cpo&vim

function! vcs_info#cvs#detect(path) abort
  let cvs = a:path . '/CVS'
  if isdirectory(cvs)
    let par = fnamemodify(a:path, ':h')
    if a:path ==# par || !isdirectory(par . '/CVS') || s:read(cvs . '/Root') !=# s:read(par . '/CVS/Root')
      return cvs
    endif
  endif
  return ''
endfunction

function! vcs_info#cvs#get(cvs_dir) abort
  return {
  \  'vcs':    'cvs',
  \  'root':   fnamemodify(a:cvs_dir, ':h'),
  \  'dir':    a:cvs_dir,
  \  'head':   s:read(a:cvs_dir . '/Repository'),
  \  'action': '',
  \}
endfunction

function! s:read(path) abort
  return filereadable(a:path) ? get(readfile(a:path), 0, '') : ''
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
