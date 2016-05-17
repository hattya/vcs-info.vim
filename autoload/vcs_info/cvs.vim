" File:        autoload/vcs_info/cvs.vim
" Author:      Akinori Hattori <hattya@gmail.com>
" Last Change: 2016-05-17
" License:     MIT License

let s:save_cpo = &cpo
set cpo&vim

let s:FP = vital#vcs_info#import('System.Filepath')

function! vcs_info#cvs#detect(path) abort
  let cvs_dir = s:FP.join(a:path, 'CVS')
  if isdirectory(cvs_dir)
    let par = s:FP.dirname(a:path)
    if par ==# a:path || !isdirectory(s:FP.join(par, 'CVS')) || vcs_info#readfile(s:FP.join(cvs_dir, 'Root')) !=# vcs_info#readfile(s:FP.join(par, 'CVS', 'Root'))
      return cvs_dir
    endif
  endif
  return ''
endfunction

function! vcs_info#cvs#get(cvs_dir) abort
  return {
  \  'vcs':    'CVS',
  \  'root':   s:FP.dirname(a:cvs_dir),
  \  'dir':    a:cvs_dir,
  \  'head':   vcs_info#readfile(s:FP.join(a:cvs_dir, 'Repository')),
  \  'action': '',
  \}
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
