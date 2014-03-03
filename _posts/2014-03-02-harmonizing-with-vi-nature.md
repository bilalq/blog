---
layout: post
title: "Harmonizing with Vi-Nature"
date: 2014-03-02 21:00
comments: false
published: true
categories: Vim Productivity
---

After using Vim for a while, it is likely that you have found yourself to be
incredibly productive within it. Those moments when you have to step outside,
however, can be painful. But they need not be.

Vim itself is just a text editor. Vi-nature, though, is becoming increasingly
universal.

> "Vim is not permanent. Nvi is not permanent. Vi itself is not permanent,
only vi-nature. Emacs has vi-nature, nano has vi-nature, even Notepad has
vi-nature. You narrow your sights, you grow attached, and hence you do not grasp
the true value of your poem’s subject." <br><small class="author">Master Wq,
<a href="http://blog.sanctum.geek.nz/vim-koans/">Vim Koans</a></small>

I've listed some applications that support the key-bindings you've become
familiar with, along with some instructions on how to get them working.

<div class="pure-g-r">
<div class="pure-u-1-5">
<h3>CLI</h3>
<ul>
<li><a href="/blog/2014/03/02/harmonizing-with-vi-nature/#readline">readline</a></li>
<li><a href="/blog/2014/03/02/harmonizing-with-vi-nature/#bash">bash</a></li>
<li><a href="/blog/2014/03/02/harmonizing-with-vi-nature/#zsh">zsh</a></li>
<li><a href="/blog/2014/03/02/harmonizing-with-vi-nature/#tmux">tmux</a></li>
</ul>
</div>
<div class="pure-u-1-5">
<h3>Browsers</h3>
<ul>
<li><a href="/blog/2014/03/02/harmonizing-with-vi-nature/#chrome">Chrome</a></li>
<li><a href="/blog/2014/03/02/harmonizing-with-vi-nature/#firefox">Firefox</a></li>
</ul>
</div>
<div class="pure-u-1-5">
<h3>Editors</h3>
<ul>
<li><a href="/blog/2014/03/02/harmonizing-with-vi-nature/#sublime">Sublime Text</a></li>
<li><a href="/blog/2014/03/02/harmonizing-with-vi-nature/#emacs">Emacs</a></li>
</ul>
</div>
<div class="pure-u-1-5">
<h3>IDEs</h3>
<ul>
<li><a href="/blog/2014/03/02/harmonizing-with-vi-nature/#eclipse">Eclipse</a></li>
<li><a href="/blog/2014/03/02/harmonizing-with-vi-nature/#xcode">Xcode</a></li>
<li><a href="/blog/2014/03/02/harmonizing-with-vi-nature/#intellij">IntelliJ</a></li>
</ul>
</div>
<div class="pure-u-1-5">
<h3>Websites</h3>
<ul>
<li><a href="/blog/2014/03/02/harmonizing-with-vi-nature/#gmail">Gmail</a></li>
<li><a href="/blog/2014/03/02/harmonizing-with-vi-nature/#github">GitHub</a></li>
</ul>
</div>
</div>

<!--more-->

<a name="readline"></a>
## readline
Readline is what a lot of CLI programs will use for handling input. If you're
using arrow keys to move around text you've entered in your bash prompt, you're
doing yourself a disservice.

With a properly configured readline, you can have bash, irb, gdb, and many other
programs all support vi-keybindings.

All you need to do is write `set editing-mode vi` to `~/.inputrc`.

If you want to get a little fancier, this is what I use:

```sh
set completion-ignore-case On
set bell-style none
set editing-mode vi

$if mode=vi
  set keymap vi-command
  "gg": beginning-of-history
  "G": end-of-history
  set keymap vi-insert
  "jj": vi-movement-mode
  "\C-p": history-search-backward
  "\C-l": clear-screen
```

The first line lets tab-compeltion be case insensitive, and the second line
silences and bell sounds. After that, I set my editing mode to vi and set up
some mappings for command mode and insert mode.

In command mode, `gg` takes me to the top of my input history and `G` to the bottom.

I prefer to use `jj` to escape rather than actually hitting escape, so I have it
mapped to return to movement mode.

The `Ctrl-p` mapping allows you to cycle through history while being in insert
mode, and `Ctrl-l` lets you clear the screen.

*Caveat: zsh does not use readline*

<a name="bash"></a>
## bash

If for whatever reason you don't vi-bindings in all of readline and only want to
affect bash, just include this in your `~/.bashrc` or `~/.bash_profile`:

```bash
set -o vi
```

<a name="zsh"></a>
## zsh

If you're a zsh user, you may have found that it does not use readline at all.
To get vi-bindings in zsh, add this to your `~/.zshrc`:

```bash
bindkey -v
```

If you want to also be able to use `jj` to enter command mode, add this line
as well:

```bash
bindkey -M viins 'jj' vi-cmd-mode
```

<a name="tmux"></a>
## tmux

Tmux and vim can become best friends with just a little bit of configuration.

The first thing you're going to want is seamless navigation from vim and tmux
splits. The
[vim-tmux-navigator](https://github.com/christoomey/vim-tmux-navigator)
completely takes care of that.

You can also use vi-bindings within tmux's copy mode. If you're on OSX, getting
tmux to copy to the system clipboard require a bit of tweaking as well.
[This post](http://robots.thoughtbot.com/tmux-copy-paste-on-os-x-a-better-future)
from thoughtbot has all the instruction you need to get things working.

This is what my `~/.tmux.conf` looks like:

```sh
# Set TERM to screen-256color in tmux
set -g default-terminal "screen-256color"

# Share the system clipboard
set-option -g default-command "reattach-to-user-namespace -l bash"

# urxvt like tab switching (-n: no prior escape seq)
bind -n S-down new-window
bind -n S-left prev
bind -n S-right next
bind -n C-left swap-window -t -1
bind -n C-right swap-window -t +1

# Status bar
set -g status-bg black
set -g status-fg white
set -g status-interval 1
set -g status-left ' '
set -g status-right '#[fg=white]%Y-%m-%d  %I:%M%p#[default] '
set-window-option -g window-status-current-bg white
set-window-option -g window-status-current-fg black

# Toggle status bar
bind-key z set -g status

# Create easier mapping to split window
bind v split-window -h

# Smart pane switching with awareness of vim splits
bind -n C-h run "(tmux display-message -p '#{pane_current_command}' | grep -iqE '(^|\/)vim$' && tmux send-keys C-h) || tmux select-pane -L"
bind -n C-j run "(tmux display-message -p '#{pane_current_command}' | grep -iqE '(^|\/)vim$' && tmux send-keys C-j) || tmux select-pane -D"
bind -n C-k run "(tmux display-message -p '#{pane_current_command}' | grep -iqE '(^|\/)vim$' && tmux send-keys C-k) || tmux select-pane -U"
bind -n C-l run "(tmux display-message -p '#{pane_current_command}' | grep -iqE '(^|\/)vim$' && tmux send-keys C-l) || tmux select-pane -R"
bind -n C-\ run "(tmux display-message -p '#{pane_current_command}' | grep -iqE '(^|\/)vim$' && tmux send-keys 'C-\\') || tmux select-pane -l"

# Use vim keybindings in copy mode
setw -g mode-keys vi

# Setup 'v' to begin selection as in Vim
bind-key -t vi-copy v begin-selection
bind-key -t vi-copy y copy-pipe "reattach-to-user-namespace pbcopy"

# Update default binding of `Enter` to also use copy-pipe
unbind -t vi-copy Enter
bind-key -t vi-copy Enter copy-pipe "reattach-to-user-namespace pbcopy"
```

<a name="chrome"></a>
## Chrome

There is a plugin for Google Chrome called
[Vimium](https://chrome.google.com/webstore/detail/vimium/dbepggeogbaibhgnhhndojpepiihcmeb?hl=en).
It's well-documented and pretty featureful.


<a name="chrome"></a>
## Firefox

There are few plugins that bring vi-bindings to Firefox, but
[Pentadactyl](https://addons.mozilla.org/en-US/firefox/addon/pentadactyl/) is
the best by far. It's more powerful than Vimium, and very much exstensible.


<a name="sublime"></a>
## Sublime Text

Sublime actually ships with vi-bindings, but has them disabled by default. Open
up the default settings and change

`"ignored_packages": ["Vintage"]`

to

`"ignored_packages": []`.


There are some extra little tweaks you might want to make as well.

While you're in the settings page, you can add this to make command mode the
default:

```json
"vintage_start_in_command_mode": true
```

Within keymap settings, I use this setting to let `jj` escape from insert mode:

```json
{ "keys": ["j", "j"], "command": "exit_insert_mode", "context":
    [
        { "key": "setting.command_mode", "operand": false },
        { "key": "setting.is_widget", "operand": false }
    ]
}
```

You can see [this page](https://www.sublimetext.com/docs/2/vintage.html) for more details on Vintage mode.


<a name="emacs"></a>
## Emacs

There are a few different ways to get vi-bindings in Emacs, but Evil seems to
be the most popular one. I'm not an emacs user, but
[here is the evil documentation](http://www.emacswiki.org/emacs/Evil).


<a name="eclipse"></a>
## Eclipse

Eclipse has a few different plugins available. I've personally found vrapper
to be the simplest one to use. You can find installation instructions
[here](http://vrapper.sourceforge.net/documentation/?page=2).

Vrapper is customizable via `~/.vrapperrc`. It doesn't have quite the
flexibility a `.vimrc` would give you, but you can do some basic things like
mapping new keybindings.

Here's what mine looks like:

```vim
inoremap jj <ESC>
```

An alternative to bringing vim into Eclipse is to bring Eclipse into vim. For
that, you can use [Eclim](http://eclim.org/). It basically lets you run a
headless Eclipse instance that you can use to bring some of Eclipse's IDE-like
features to vim.


<a name="xcode"></a>
## Xcode

If you're developing OSX or iOS applications, you're going to be very sad if
you try to do so outside of Xcode. Fortunately, XVim exists to bring vi-bindings
to it.

You'll have to download the xcodeproject and build it yourself to use it.
Instructions are in the README found in the
[github repo](https://github.com/JugglerShu/XVim).

You can also customize XVim via `~/.xvimrc`. This is what mine looks like:

```vim
" Key Mappings "
imap jj <Esc>
nmap <Space> <C-d>
nmap n nzz
nmap N Nzz

" Search Settings "
set incsearch
set ignorecase
set smartcase
```


<a name="intellij"></a>
## IntelliJ

Any of the IDEs in the IntelliJ family can support vi-bindings via the
[IdeaVim](https://github.com/JetBrains/ideavim) plugin. The list includes:

* IntelliJ IDEA
* RubyMine
* PyCharm
* PhpStorm
* WebStorm
* AppCode
* Android Studio

A major shortcoming of this plugin, however, is that it does not support
custom keymappings.


<a name="gmail"></a>
## Gmail

If you open up the settings page in Gmail and set keyboard shortcuts to on,
you'll find that Gmail has some nice vi-like keybindings built in. Once you have
them enabled, you can press `?` to bring up a friendly help window.

If you're using a browser plugin that has vi-bindings, be sure to add Gmail to
the list of excluded websites.

Sparrow users on OSX, can also access these same keyboard shortcuts to by
checking `Use Gmail shortcuts` under advanced preferences.


<a name="github"></a>
## GitHub

Much like Gmail, GitHub has some awesome vi-like keyboard shortcuts. You can
press `?` to bring up a help pane that shows you the available commands.

Be sure to add GitHub to the list of excluded sites of your vi browser plugin if
you have one.
