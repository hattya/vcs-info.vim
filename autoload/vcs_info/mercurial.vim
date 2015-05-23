" File:        autoload/vcs_info/mercurial.vim
" Author:      Akinori Hattori <hattya@gmail.com>
" Last Change: 2015-05-23
" License:     MIT License

let s:save_cpo = &cpo
set cpo&vim

function! vcs_info#mercurial#detect(path) abort
  let _hg = a:path . '/.hg'
  return isdirectory(_hg) ? _hg : ''
endfunction

function! vcs_info#mercurial#get(hg_dir) abort
  let info = {
  \  'vcs':    'mercurial',
  \  'root':   fnamemodify(a:hg_dir, ':h'),
  \  'dir':    a:hg_dir,
  \  'head':   'default',
  \  'action': '',
  \}
  if filereadable(a:hg_dir . '/branch')
    let info.head = s:read(a:hg_dir . '/branch')
  endif
  if filereadable(a:hg_dir . '/bookmarks.current')
    let mark = s:read(a:hg_dir . '/bookmarks.current')
    if mark !=# '@'
      let info.head = mark
    endif
  endif
  if isdirectory(a:hg_dir . '/merge')
    let info.action = 'merge'
  elseif filereadable(a:hg_dir . '/rebasestate')
    let info.action = 'rebase'
  endif
  return info
endfunction

function! s:read(path) abort
  return filereadable(a:path) ? get(readfile(a:path), 0, '') : ''
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
