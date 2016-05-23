" File:        autoload/vcs_info/subversion.vim
" Author:      Akinori Hattori <hattya@gmail.com>
" Last Change: 2016-05-23
" License:     MIT License

let s:save_cpo = &cpo
set cpo&vim

let s:FP = vital#vcs_info#import('System.Filepath')

function! vcs_info#subversion#detect(path) abort
  let svn_dir = s:FP.join(a:path, '.svn')
  if vcs_info#any(svn_dir, ['wc.db', 'entries', 'format'])
    let info = s:svn_info(a:path)
    if has_key(info, 'Working Copy Root Path')
      if a:path ==# info['Working Copy Root Path']
        return svn_dir
      endif
    else
      let par = s:FP.dirname(a:path)
      if par ==# a:path || !isdirectory(s:FP.join(par, '.svn')) || get(s:svn_info(par), 'Repository UUID') !=# info['Repository UUID']
        return svn_dir
      endif
    endif
  endif
  return ''
endfunction

function! vcs_info#subversion#get(svn_dir) abort
  let info = s:svn_info(s:FP.dirname(a:svn_dir))
  return {
  \  'vcs':    'Subversion',
  \  'root':   s:FP.dirname(a:svn_dir),
  \  'dir':    a:svn_dir,
  \  'head':   substitute(info['URL'], '^.*/', '', '') . '@' . info['Revision'],
  \  'action': '',
  \}
endfunction

function! s:svn_info(path) abort
  let info = {}
  for l in vcs_info#system(['svn', 'info', '--non-interactive', a:path])
    let i = stridx(l, ':')
    if i != -1
      let info[s:trim(l[: i-1])] = s:trim(l[i+1 :])
    endif
  endfor
  return info
endfunction

function! s:trim(s) abort
  return matchstr(a:s, '\v^\s*\zs.{-}\ze\s*$')
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
