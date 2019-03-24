" File:        autoload/vcs_info/bazaar.vim
" Author:      Akinori Hattori <hattya@gmail.com>
" Last Change: 2019-03-24
" License:     MIT License

let s:save_cpo = &cpo
set cpo&vim

let s:FP = vital#vcs_info#import('System.Filepath')

function! vcs_info#bazaar#detect(path) abort
  let bzr_dir = s:FP.join(a:path, '.bzr')
  return vcs_info#all(bzr_dir, ['branch']) ? bzr_dir : ''
endfunction

function! vcs_info#bazaar#get(bzr_dir) abort
  let root = s:FP.dirname(a:bzr_dir)
  let conflicts = s:FP.join(a:bzr_dir, 'checkout', 'conflicts')
  let info = {
  \  'vcs':    'Bazaar',
  \  'root':   root,
  \  'dir':    a:bzr_dir,
  \  'head':   s:FP.basename(root),
  \  'action': filereadable(conflicts) && len(readfile(conflicts)) > 1 ? 'merge' : '',
  \}
  if filereadable(s:FP.join(a:bzr_dir, 'branch', 'branch.conf'))
    for l in readfile(s:FP.join(a:bzr_dir, 'branch', 'branch.conf'))
      let nick = matchstr(l, '^\s*nickname\s*=\s*\zs.\{-}\ze\s*$')
      if nick !=# ''
        let info.head = nick
        break
      endif
    endfor
  endif
  return info
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
