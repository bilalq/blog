---
layout: post
title: "Getting Started with Vim"
date: 2012-12-17 21:36
comments: true
published: true
categories: [Vim, Productivity, Guide]
---

This is a brief guide to get you acquainted with using Vim in the terminal. If
you're reading this, you've probably heard of Vim already. For those that
haven't, it's a text-editor that's a bit different than most. It's optimized for
touch typists, and eschews the use of a mouse in favor of keyboard shortcuts.
Rather than binding controls to modifiers such as the `Ctrl` or `Alt` keys, Vim
makes use of different editing __*modes*__. When you're just navigating your
code base, you're in `NORMAL MODE`.When you want to type in text, you go into
`INSERT MODE`. This talk of modes might not make sense just yet, but read on,
and you will see the light.

I won't lie to you, Vim has a steep learning curve. It can intimidating at
first, even daunting. In the beginning, you will feel sluggish, wondering why
it's so difficult to do basic things. You will be confused. You may even be
frightened. It'll take some time, but the rewards will prove to be worth it in
the end.

<!--more-->

## Get What You Need ##
The first step on your journey is to get Vim on your machine. If you're running
Linux or OSX, chances are that you already have it. Windows users can grab it
[here](http://www.vim.org/download.php), or run it under some equivalent of
Cygwin.

If you're on Ubuntu, Vim is there, but it's sort of hidden away under the guise
of Vi. You can improve your experience by installing a package that has Vim
compiled with some nicer flags. This should set you straight:

`sudo apt-get install vim-gtk`

If you're on a Mac, then you have Vim, but it's probably a little dated and
missing some cool features. If you don't already have Brew, you'll want to grab
that [here](http://mxcl.github.com/homebrew/) and install it. Once you've done
that, open up a terminal and type in this command:

`brew install macvim --override-system-vim`

Both of these install instructions also get you GUI versions of Vim. They can be
a bit nicer in terms of appearance, but you lose out on the flexibility of being
in a terminal if you choose to go with them.


## Play Around ##
You can only get so much out of reading guides and blogposts. Now that you have
Vim installed, it's time to take the plunge. Open up a terminal, and type in:

`vimtutor`

This will launch an interactive guide. I know it says that it should take about
30 minutes to go through it, but don't be afraid to take longer if you need it.
Go through it completely before coming back to this guide.

## Improve Your Understanding ##
Having gone through `vimtutor`, you should have some familiarity with Vim. It's
perfectly normal to not remember most things. Below, you'll find a quick
cheatsheet of the more useful commands in normal mode. Wherever you see a
`<CR>`, take that to mean "Hit the Enter/Return key". It stands for "carriage
return" if you were curious. Oh, and remember that escape will take you back
into Normal mode.

    :q<CR>      quit
    :q!<CR>     quit without saving
    :w<CR>      save
    u           undo
    Ctrl r      redo
    i           go into Insert mode at the cursor
    a           go into after the cursor

The best way to get better in Vim is to keep programming. These basic commands
should be enough to get you started. If you have to stop and look up how to do
something every now and then, it's fine.


## Customize Vim ##

Part of the reason why Vim is so well-loved is because of how customizable it
is. Linux and OSX users can save these settings in a file called `.vimrc` that
is located in their home folders. Windows folks can use
[this guide](http://superuser.com/questions/86246/where-should-the-vimrc-file-be-located-on-windows-7)
to help them find where there vimrc should go.

Customizing vim is a rather advanced topic, and I won't cover much here.
However, certain Vim defaults absolutely suck. The only way to go about fixing
them is to actually change them. Welcome to the Wonderful World of Vimscript.

Below here, I have a simple `.vimrc` file that I like to give out to people just
getting started with Vim. Feel free to take it and run with it. It's pretty well
commented, so this should be enough to get you started.

``` vim .vimrc
"A simple vimrc that I give to people just starting to use Vim."
"Lines beginning with a double quote are comments."

"Basic settings
"=======================================================================
set nocompatible "Fixes old Vi bugs
syntax on
set backspace=2 "Makes backspace work
set history=500 "Sets undo history size
set ruler "Sets up status bar
set laststatus=2 "Always keeps the status bar active
set number "Turns on line numbering
set t_Co=256 "Sets Vim to use 256 colors
colorscheme elflord


"Indentation settings
"=======================================================================
set tabstop=4 "Sets display width of tabs
set shiftwidth=4 "Sets indentation width
set autoindent "Turns on auto-indenting
set smartindent "Remembers previous indent when creating new lines
"
"Choose between tabs and spaces for indentation by uncommenting one of
"these two. Expand for spaces, noexpand for tabs:"
"set noexpandtab
"set expandtab
"
set smarttab "Smarter indentation management regardless of tabs/spaces


"Search settings
"=======================================================================
set hlsearch "Highlights search terms
set showmatch "Highlights matching parentheses
set ignorecase "Ignores case when searching
set smartcase "Unless you put some caps in your search term


"Key mappings
"=======================================================================
"Use jj instead of escape in insert mode
inoremap jj <Esc>`^


"Turn on plugin & indentation support for specific filetypes
filetype plugin indent on
```

## Keep Learning ##

I'll probably write more about Vim in the future, but there are plenty of other
resources around if you're interested in learning more. There's no substitute
for actual experience though.

* [VimCasts](http://vimcasts.org)
* [Vim Adventures](http://vim-adventures.com/)
* [TutsPlus Links](http://net.tutsplus.com/articles/web-roundups/25-vim-tutorials-screencasts-and-resources/)
