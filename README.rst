vcs-info.vim
============

vcs-info.vim is a Vim plugin to retrieve VCS information of the working
directory where the currently edited file exists. It is inspired by Zsh_'s
vcs_info_.

.. image:: https://drone.io/github.com/hattya/vcs-info.vim/status.png
   :target: https://drone.io/github.com/hattya/vcs-info.vim/latest

.. image:: https://ci.appveyor.com/api/projects/status/4yda92saqm3sj6nd?svg=true
   :target: https://ci.appveyor.com/project/hattya/vcs-info-vim

.. image:: https://img.shields.io/badge/powered_by-vital.vim-80273f.svg
   :target: https://github.com/vim-jp/vital.vim

.. image:: https://img.shields.io/badge/doc-:h%20vcs--info-blue.svg
   :target: doc/vcs-info.txt

.. _Zsh: http://www.zsh.org/
.. _vcs_info: http://zsh.sourceforge.net/Doc/Release/User-Contributions.html#Version-Control-Information


Installation
------------

pathogen.vim_

.. code:: console

   $ cd ~/.vim/bundle
   $ git clone https://github.com/hattya/vcs-info.vim

Vundle_

.. code:: vim

   Plugin 'hattya/vcs-info.vim'

NeoBundle_

.. code:: vim

   NeoBundle 'hattya/vcs-info.vim'

vim-plug_

.. code:: vim

   Plug 'hattya/vcs-info.vim'

.. _pathogen.vim: https://github.com/tpope/vim-pathogen
.. _Vundle: https://github.com/VundleVim/Vundle.vim
.. _NeoBundle: https://github.com/Shougo/neobundle.vim
.. _vim-plug: https://github.com/junegunn/vim-plug


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
