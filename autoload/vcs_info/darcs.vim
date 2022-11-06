" File:        autoload/vcs_info/darcs.vim
" Author:      Akinori Hattori <hattya@gmail.com>
" Last Change: 2022-11-06
" License:     MIT License

let s:save_cpo = &cpo
set cpo&vim

let s:FP = vital#vcs_info#import('System.Filepath')

function! vcs_info#darcs#detect(path) abort
  let darcs_dir = s:FP.join(a:path, '_darcs')
  return vcs_info#all(darcs_dir, ['format']) ? darcs_dir : ''
endfunction

function! vcs_info#darcs#get(darcs_dir) abort
  let root = s:FP.dirname(a:darcs_dir)
  return {
  \  'vcs':    'Darcs',
  \  'root':   root,
  \  'dir':    a:darcs_dir,
  \  'head':   s:FP.basename(root),
  \  'action': '',
  \}
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
