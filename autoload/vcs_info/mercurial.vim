" File:        autoload/vcs_info/mercurial.vim
" Author:      Akinori Hattori <hattya@gmail.com>
" Last Change: 2016-05-17
" License:     MIT License

let s:save_cpo = &cpo
set cpo&vim

let s:FP = vital#vcs_info#import('System.Filepath')

function! vcs_info#mercurial#detect(path) abort
  let _hg = s:FP.join(a:path, '.hg')
  return isdirectory(_hg) ? _hg : ''
endfunction

function! vcs_info#mercurial#get(hg_dir) abort
  let info = {
  \  'vcs':    'mercurial',
  \  'root':   s:FP.dirname(a:hg_dir),
  \  'dir':    a:hg_dir,
  \  'head':   'default',
  \  'action': '',
  \}
  if filereadable(s:FP.join(a:hg_dir, 'branch'))
    let info.head = s:read(s:FP.join(a:hg_dir, 'branch'))
  endif
  if filereadable(s:FP.join(a:hg_dir, 'bookmarks.current'))
    let mark = s:read(s:FP.join(a:hg_dir, 'bookmarks.current'))
    if mark !=# '@'
      let info.head = mark
    endif
  endif
  let info.action = isdirectory(s:FP.join(a:hg_dir, 'merge'))        ? 'merge' :
  \                 filereadable(s:FP.join(a:hg_dir, 'rebasestate')) ? 'rebase' :
  \                                                                    ''
  return info
endfunction

function! s:read(path) abort
  return filereadable(a:path) ? get(readfile(a:path), 0, '') : ''
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
