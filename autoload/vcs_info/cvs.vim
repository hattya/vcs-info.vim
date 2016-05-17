" File:        autoload/vcs_info/cvs.vim
" Author:      Akinori Hattori <hattya@gmail.com>
" Last Change: 2016-05-17
" License:     MIT License

let s:save_cpo = &cpo
set cpo&vim

let s:FP = vital#vcs_info#import('System.Filepath')

function! vcs_info#cvs#detect(path) abort
  let cvs = s:FP.join(a:path, 'CVS')
  if isdirectory(cvs)
    let par = s:FP.dirname(a:path)
    if a:path ==# par || !isdirectory(s:FP.join(par, 'CVS')) || s:read(s:FP.join(cvs, 'Root')) !=# s:read(s:FP.join(par, 'CVS', 'Root'))
      return cvs
    endif
  endif
  return ''
endfunction

function! vcs_info#cvs#get(cvs_dir) abort
  return {
  \  'vcs':    'cvs',
  \  'root':   s:FP.dirname(a:cvs_dir),
  \  'dir':    a:cvs_dir,
  \  'head':   s:read(s:FP.join(a:cvs_dir, 'Repository')),
  \  'action': '',
  \}
endfunction

function! s:read(path) abort
  return filereadable(a:path) ? get(readfile(a:path), 0, '') : ''
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
