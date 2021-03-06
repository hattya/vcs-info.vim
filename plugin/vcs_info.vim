" File:        plugin/vcs_info.vim
" Author:      Akinori Hattori <hattya@gmail.com>
" Last Change: 2018-01-20
" License:     MIT License

if exists('g:loaded_vcs_info')
  finish
endif
let g:loaded_vcs_info = 1

let s:save_cpo = &cpo
set cpo&vim

augroup vcs-info
  autocmd!
  autocmd BufNewFile,BufReadPost * call vcs_info#detect(expand('<amatch>'))
  autocmd BufEnter               * call vcs_info#detect(expand('%:p'))
augroup END

call vcs_info#reload()

let &cpo = s:save_cpo
unlet s:save_cpo
