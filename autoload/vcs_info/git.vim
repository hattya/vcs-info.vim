" File:        autoload/vcs_info/git.vim
" Author:      Akinori Hattori <hattya@gmail.com>
" Last Change: 2015-05-26
" License:     MIT License

let s:save_cpo = &cpo
set cpo&vim

function! vcs_info#git#detect(path) abort
  let _git = a:path . '/.git'
  let ft = getftype(_git)
  if ft ==# 'dir'
    if isdirectory(_git . '/objects') &&
    \  isdirectory(_git . '/refs') &&
    \  10 < getfsize(_git . '/HEAD')
      return _git
    endif
  elseif ft ==# 'file'
    let rel = s:read(_git)
    let i = matchend(rel, '^gitdir:\s*')
    if i != -1
      return simplify(a:path . '/' . rel[i :])
    endif
  endif
  return ''
endfunction

function! vcs_info#git#get(git_dir) abort
  let info = {
  \  'vcs':    'git',
  \  'root':   substitute(a:git_dir, '/\.git\%(/modules\)\=', '', ''),
  \  'dir':    a:git_dir,
  \  'head':   '',
  \  'action': '',
  \}
  if isdirectory(a:git_dir . '/rebase-apply')
    let info.head = s:symbolic_ref(a:git_dir)
    if empty(info.head)
      let info.head = s:read(a:git_dir . '/rebase-apply/head-name')
    endif
    if filereadable(a:git_dir . '/rebase-apply/rebasing')
      let info.action = 'rebase'
    elseif filereadable(a:git_dir . '/rebase-apply/applying')
      let info.action = 'am'
    else
      let info.action = 'am/rebase'
    endif
  elseif isdirectory(a:git_dir . '/rebase-merge')
    let info.head = s:read(a:git_dir . '/rebase-merge/head-name')
    let info.action = filereadable(a:git_dir . '/rebase-merge/interactive') ? 'rebase-i' : 'rebase-m'
  elseif filereadable(a:git_dir . '/MERGE_HEAD')
    let info.head = s:symbolic_ref(a:git_dir)
    if empty(info.head)
      let info.head = vcs_info#abbr(s:read(a:git_dir . '/MERGE_HEAD'))
    endif
    let info.action = 'merge'
  else
    let info.head = s:symbolic_ref(a:git_dir)
    if empty(info.head)
      let head = s:read(a:git_dir . '/HEAD')
      let info.head = s:find_ref(a:git_dir, head)
      if empty(info.head)
        let info.head = vcs_info#abbr(head)
      endif
    endif
    if filereadable(a:git_dir . '/BISECT_LOG')
      let info.action = 'bisect'
    elseif filereadable(a:git_dir . '/CHERRY_PICK_HEAD')
      let info.action = 'cherry'
    endif
  endif
  let i = matchend(info.head, '^refs/.\{-}/')
  if i != -1
    let info.head = info.head[i :]
  endif
  return info
endfunction

function! s:find_ref(git_dir, hash) abort
  for ref in split(glob(a:git_dir . '/refs/*/*', 1), '\n')
    if ref =~# '\v/refs/%(heads|tags)/' && s:read(ref) ==# a:hash
      return ref[len(a:git_dir) + 1 :]
    endif
  endfor
  if filereadable(a:git_dir . '/packed-refs')
    let tag = ''
    for l in readfile(a:git_dir . '/packed-refs')[1 :]
      if l[0] ==# '^'
        if l[1 :] ==# a:hash
          return tag
        endif
      else
        let ref = l[41 :]
        if l[: 39] ==# a:hash
          if ref =~# '\v^refs/%(heads|tags)/'
            return ref
          endif
        elseif ref =~# '^refs/tags/'
          let tag = ref
        endif
      endif
    endfor
  endif
  return ''
endfunction

function! s:symbolic_ref(path) abort
  let head = s:read(a:path . '/HEAD')
  let i = matchend(head, '^ref:\s*')
  return i != -1 ? head[i :] : ''
endfunction

function! s:read(path) abort
  return filereadable(a:path) ? get(readfile(a:path), 0, '') : ''
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
