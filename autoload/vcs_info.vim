" File:        autoload/vcs_info.vim
" Author:      Akinori Hattori <hattya@gmail.com>
" Last Change: 2015-05-21
" License:     MIT License

let s:save_cpo = &cpo
set cpo&vim

let s:vcses = []

function! vcs_info#detect(path) abort
  unlet! b:vcs_info
  let path = substitute(a:path, '\\', '/', 'g')
  let prev = ''
  while path !=# prev
    for vcs in s:vcses
      let dir = call('vcs_info#' . vcs . '#detect', [path])
      if !empty(dir)
        let b:vcs_info = {
        \  'vcs': vcs,
        \  'dir': dir,
        \}
        return
      endif
    endfor
    let prev = path
    let path = fnamemodify(path, ':h')
  endwhile
endfunction

function! vcs_info#get() abort
  if !exists('b:vcs_info')
    return {}
  endif
  return call('vcs_info#' . b:vcs_info.vcs . '#get', [b:vcs_info.dir])
endfunction

function! vcs_info#abbr(hash) abort
  let n = get(b:, 'vcs_info_abbr', get(g:, 'vcs_info_abbr', 7))
  return 0 < n ? a:hash[: n - 1] : ''
endfunction

function! vcs_info#reload() abort
  let s:vcses = []
  for f in split(globpath(&runtimepath, 'autoload/vcs_info/*.vim', 1), '\n')
    call add(s:vcses, fnamemodify(f, ':t:r'))
  endfor
  call sort(s:vcses)
endfunction

call vcs_info#reload()

let &cpo = s:save_cpo
unlet s:save_cpo
