vcs-info.vim
============

vcs-info.vim is a Vim plugin to retrieve VCS information of the working
directory where the currently edited file exists. It is inspired by Zsh_'s
vcs_info_.

.. image:: https://github.com/hattya/vcs-info.vim/actions/workflows/ci.yml/badge.svg
   :target: https://github.com/hattya/vcs-info.vim/actions/workflows/ci.yml

.. image:: https://semaphoreci.com/api/v1/hattya/vcs-info-vim/branches/master/badge.svg
   :target: https://semaphoreci.com/hattya/vcs-info-vim

.. image:: https://ci.appveyor.com/api/projects/status/4yda92saqm3sj6nd/branch/master?svg=true
   :target: https://ci.appveyor.com/project/hattya/vcs-info-vim

.. image:: https://codecov.io/gh/hattya/vcs-info.vim/branch/master/graph/badge.svg
   :target: https://codecov.io/gh/hattya/vcs-info.vim

.. image:: https://img.shields.io/badge/powered_by-vital.vim-80273f.svg
   :target: https://github.com/vim-jp/vital.vim

.. image:: https://img.shields.io/badge/doc-:h%20vcs--info.txt-blue.svg
   :target: doc/vcs-info.txt

.. _Zsh: http://www.zsh.org/
.. _vcs_info: http://zsh.sourceforge.net/Doc/Release/User-Contributions.html#Version-Control-Information


Installation
------------

Vundle_

.. code:: vim

   Plugin 'hattya/vcs-info.vim'

vim-plug_

.. code:: vim

   Plug 'hattya/vcs-info.vim'

dein.vim_

.. code:: vim

   call dein#add('hattya/vcs-info.vim')

.. _Vundle: https://github.com/VundleVim/Vundle.vim
.. _vim-plug: https://github.com/junegunn/vim-plug
.. _dein.vim: https://github.com/Shougo/dein.vim


Requirements
------------

- Vim 8.0+


Usage
-----

.. code:: vim

   let info = vcs_info#get()
   if !empty(info)
     let s = info.head
     if info.action !=# ''
       let s .= ':' . info.action
     endif
   endif


Testing
-------

vcs-info.vim uses themis.vim_ for testing.

.. code:: console

   $ cd /path/to/vcs-info.vim
   $ git clone https://github.com/thinca/vim-themis
   $ ./vim-themis/bin/themis

.. _themis.vim: https://github.com/thinca/vim-themis


License
-------

vcs-info.vim is distributed under the terms of the MIT License.
