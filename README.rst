vcs-info.vim
============

vcs-info.vim is a Vim plugin to retrieve VCS information of the working copy
where the currently edited file exists. It is inspired by Zsh_'s vcs_info_.

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
