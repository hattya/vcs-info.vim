" File:        autoload/vcs_info/git.vim
" Author:      Akinori Hattori <hattya@gmail.com>
" Last Change: 2019-03-24
" License:     MIT License

let s:save_cpo = &cpo
set cpo&vim

let s:V = vital#vcs_info#import('Prelude')
let s:FP = vital#vcs_info#import('System.Filepath')

function! vcs_info#git#detect(path) abort
  let git_dir = s:FP.join(a:path, '.git')
  let ft = getftype(git_dir)
  if ft ==# 'dir'
    if vcs_info#all(git_dir, ['objects', 'refs']) && getfsize(s:FP.join(git_dir, 'HEAD')) > 10
      return git_dir
    endif
  elseif ft ==# 'file'
    let rel = vcs_info#readfile(git_dir)
    let i = matchend(rel, '^gitdir:\s*')
    if i != -1
      return simplify(s:FP.join(a:path, vcs_info#from_slash(rel[i :])))
    endif
  endif
  return ''
endfunction

function! vcs_info#git#get(git_dir) abort
  let sep = escape(s:FP.separator(), '\')
  let info = {
  \  'vcs':    'Git',
  \  'root':   substitute(a:git_dir, '\v' . sep . '\.git%(' . sep . 'modules)=', '', ''),
  \  'dir':    a:git_dir,
  \  'head':   '',
  \  'action': '',
  \}
  if isdirectory(s:FP.join(a:git_dir, 'rebase-apply'))
    let info.head = s:symbolic_ref(a:git_dir)
    if info.head ==# ''
      let info.head = vcs_info#readfile(s:FP.join(a:git_dir, 'rebase-apply', 'head-name'))
    endif
    let info.action = filereadable(s:FP.join(a:git_dir, 'rebase-apply', 'rebasing')) ? 'rebase' :
    \                 filereadable(s:FP.join(a:git_dir, 'rebase-apply', 'applying')) ? 'am' :
    \                                                                                  'am/rebase'
  elseif isdirectory(s:FP.join(a:git_dir, 'rebase-merge'))
    let info.head = vcs_info#readfile(s:FP.join(a:git_dir, 'rebase-merge', 'head-name'))
    let info.action = filereadable(s:FP.join(a:git_dir, 'rebase-merge', 'interactive')) ? 'rebase-i' : 'rebase-m'
  elseif filereadable(s:FP.join(a:git_dir, 'MERGE_HEAD'))
    let info.head = s:symbolic_ref(a:git_dir)
    if info.head ==# ''
      let info.head = vcs_info#abbr(vcs_info#readfile(s:FP.join(a:git_dir, 'MERGE_HEAD')))
    endif
    let info.action = 'merge'
  else
    let info.head = s:symbolic_ref(a:git_dir)
    if info.head ==# ''
      let head = vcs_info#readfile(s:FP.join(a:git_dir, 'HEAD'))
      let info.head = s:find_ref(a:git_dir, head)
      if info.head ==# ''
        let info.head = vcs_info#abbr(head)
      endif
    endif
    let info.action = filereadable(s:FP.join(a:git_dir, 'BISECT_LOG'))       ? 'bisect' :
    \                 filereadable(s:FP.join(a:git_dir, 'CHERRY_PICK_HEAD')) ? 'cherry' :
    \                                                                          ''
  endif
  let i = matchend(info.head, '^refs/.\{-}/')
  if i != -1
    let info.head = info.head[i :]
  endif
  return info
endfunction

function! s:find_ref(git_dir, hash) abort
  let pat = vcs_info#from_slash('\v/refs/%(heads|tags)/')
  for ref in s:V.glob(s:FP.join(a:git_dir, 'refs', '*', '*'))
    if ref =~# pat && vcs_info#readfile(ref) ==# a:hash
      return ref[len(a:git_dir)+1 :]
    endif
  endfor
  if filereadable(s:FP.join(a:git_dir, 'packed-refs'))
    let tag = ''
    for l in readfile(s:FP.join(a:git_dir, 'packed-refs'))[1 :]
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
  let head = vcs_info#readfile(s:FP.join(a:path, 'HEAD'))
  let i = matchend(head, '^ref:\s*')
  return i != -1 ? head[i :] : ''
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
