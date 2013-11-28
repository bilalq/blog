---
layout: post
title: "Removing Distractions From Vim"
date: 2013-11-25 04:00
comments: true
published: true
categories: Vim Productivity
---

Sublime Text is a text editor that has rapidly grown in popularity. While I
still prefer Vim, I love some of the features that Sublime Text has. Among them
is something called *Distraction Free Mode*.

As one might expect, there are plugins that aim to bring similar functionality
to Vim. [VimRoom](http://projects.mikewest.org/vimroom/) and
[Distraction Free Writing With Vim](http://www.laktek.com/2012/09/05/distraction-free-writing-with-vim/)
are the two that I am familiar with. I had issues with both of them, but they
may work out for you.

Out of frustration, I ended up writing my own plugin called
[LiteDFM](https://github.com/bilalq/lite-dfm). I wasn't really trying to
do anything complicated, but I ended up with a poor man's Distraction Free Mode
(DFM).

<!--more-->

## My usual Vim session
<img src="/img/removing-distractions-from-vim/before.png" alt="My usual vim apperance" style="width:100%;max-width:732px;max-height:444px;" />

## My Vim with LiteDFM on
<img src="/img/removing-distractions-from-vim/after.png" alt="Vim's apperance with LiteDFM on" style="width:100%;max-width:732px;max-height:444px;" />

<a name="intro"></a>
## Using LiteDFM

If you're using [Vundle](https://github.com/gmarik/vundle), you can install it
by adding this to your `.vimrc` and running `:BundleInstall`:

{% highlight vim %}
Bundle 'bilalq/lite-dfm'
{% endhighlight %}

For the sake of convenience, you may want to create a mapping to toggle DFM.
The one I use is:

{% highlight vim %}
nnoremap <Leader>z :LiteDFMToggle<CR>i<Esc>`^
{% endhighlight %}

The `i<Esc>` at the end is there to immediately hide the message that shows the
last command. Changing the mode and back is a bit of a dirty hack, but it gets
the job done. The `` `^`` keeps the cursor steady after the mode change, since
leaving `INSERT` mode usually moves the cursor back a column.

If you're a tmux user, you may also want something that will let you toggle the
status bar there as well. Adding this line to your `.tmux.conf` should do the
trick:

```
bind-key z set -g status
```

## How it Works

In Sublime, DFM hides all UI chrome, centers text, and soft-wraps line lengths.
What I have here falls short of that.

Centering text turned out to be a bit challenging. However, there was something
natural that offset text from the left: the line number column. By default,
it has a width of 4, and the largest it goes is 10. I was able to make use of
that by setting the foreground and background colors for line numbers such that
they appeared invisible. This isn't centering, but it does get your code away
from the left edge of the screen.

Aside from line numbers, the statusbar and ruler are also UI elements that
toggling LiteDFM hides. Upon toggling off LiteDFM, settings revert to what they
were before.

It works for multiple windows as well. With a `vsplit`, it can even pass for
centering.

At the present I'm not even sure how I'd go about softwrapping text.

## It's Funny

For a while now, I had the functional equivalent of this plugin with just 2
lines in my `.vimrc`.

{% highlight vim %}
nnoremap <Leader>z :set numberwidth=10 set laststatus=0<CR>:hi LineNr ctermfg=237 ctermbg=237<CR>i<Esc>`^
nnoremap <Leader>Z :set numberwidth=4  set laststatus=2<CR>:hi LineNr ctermfg=101 ctermbg=238<CR>i<Esc>`^
{% endhighlight %}

Of course, these lines were hardcoded to my current vim configuration. Making them sharable/portable required a bit of work.

## Caveats

There are currently two issues that I am aware of:

* If you change your colorscheme after the plugin has loaded, you will have to
  reload it in order for it to set the correct `LineNr` colors.
* If you have a value of `none` for your `Normal` bg color, the line numbers
  will still be visible.

I'm still working on fixing these two bugs.
