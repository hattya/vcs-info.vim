" File:        autoload/vcs_info/fossil.vim
" Author:      Akinori Hattori <hattya@gmail.com>
" Last Change: 2019-06-08
" License:     MIT License

let s:save_cpo = &cpo
set cpo&vim

function! vcs_info#fossil#detect(path) abort
  return vcs_info#any(a:path, ['.fslckout', '_FOSSIL_']) ? a:path : ''
endfunction

function! vcs_info#fossil#get(fsl_dir) abort
  let [info, changes] = s:status(a:fsl_dir)
  return {
  \  'vcs':    'Fossil',
  \  'root':   a:fsl_dir,
  \  'dir':    a:fsl_dir,
  \  'head':   split(info['tags'], ',\s*')[0],
  \  'action': !empty(filter(keys(changes), 'v:val =~# "\\v^%(CONFLICT|EDITED|%(ADD|UPDAT)ED_BY_%(MERGE|INTEGRATE))$"')) ? 'merge' : '',
  \}
endfunction

function! s:status(path) abort
  let cwd = getcwd()
  execute 'cd' a:path
  try
    let info = {}
    let changes = {}
    for l in vcs_info#system(['fossil', 'status'])
      let i = stridx(l, ' ')
      if l[i-1] ==# ':'
        let info[l[: i-2]] = vcs_info#trim(l[i :])
      else
        let k = l[: i-1]
        let changes[k] = add(get(changes, k, []), vcs_info#trim(l[i :]))
      endif
    endfor
    return [info, changes]
  finally
    execute 'cd' cwd
  endtry
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
