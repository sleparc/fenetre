fenetre.vim
===========

This is a basic plugin that saves the configuration of your Vim windows 
and let you open them again later

Installation
------------

If you don't have a preferred installation method, I recommend
installing [pathogen.vim](https://github.com/tpope/vim-pathogen), and
then simply copy and paste:

    cd ~/.vim/bundle
    git clone git://github.com/sleparc/fenetre.git

Usage
-----

When you want to save your current configuration:

    :call FenetreSaveSession()

When you want to restore your saved configuration:

    :call FenetreOpenSession()


The configuration file is saved at:

    ~/.fenetre_sessions

ToDos
-----
* Open NERDTree When BufferName is NERD_tree_1
* Make sure FenetreSaveSession bring cursor back in right window
* User should be able to save a session configuration with a specific name
