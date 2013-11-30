---
layout: post
title: "Removing Distractions From Vim"
date: 2013-11-27 20:00
comments: true
published: true
categories: Vim Productivity
---
<small>*Updated: 30 Nov 2013*</small>

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
<img src="/img/removing-distractions-from-vim/dfm_off.png" alt="My usual vim apperance" style="width:100%;max-width:738px;max-height:445px;" />

## My Vim with LiteDFM on
<img src="/img/removing-distractions-from-vim/dfm_on.png" alt="Vim's apperance with LiteDFM on" style="width:100%;max-width:738px;max-height:445px;" />

<a name="intro"></a>
## Using LiteDFM

You can find the source up on [GitHub](https://github.com/bilalq/lite-dfm).

If you're using [Vundle](https://github.com/gmarik/vundle), you can install it
by adding this to your `.vimrc` and running `:BundleInstall`.

{% highlight vim %}
Bundle 'bilalq/lite-dfm'
{% endhighlight %}

For some added convenience, you may want to create a mapping to toggle DFM.
The one I use is:

{% highlight vim %}
nnoremap <Leader>z :LiteDFMToggle<CR>i<Esc>`^
{% endhighlight %}

The `i<Esc>` at the end is there to immediately hide the message that shows the
last command. Changing the mode and back is a bit of a dirty hack, but it gets
the job done. The `` `^`` keeps the cursor steady after the mode change, since
leaving `INSERT` mode usually moves the cursor back a column.

If you're a tmux user, you may want it to toggle the status bar there as well:

{% highlight vim %}
nnoremap <Leader>z :LiteDFMToggle<CR>:silent !tmux set status > /dev/null<CR>:redraw!<CR>
{% endhighlight %}

## How it Works

In Sublime, DFM hides all UI chrome, centers text, and soft-wraps line lengths.
What I have here falls a bit short of that.

Centering text turned out to be a bit challenging. However, there were some
things that naturally offset text from the left: the line number and fold
columns. By default, `numberwidth` is set to 4, and the largest it goes is 10.
`foldcolumn` defaults to 0, and maxes at 12.  By making use of these two, I was
able to offset by 22 columns. When you activate LiteDFM, it applies this offset
to each window.

Of course, I didn't want anything distracting in these columns, so I set the
foreground and background colors for these such that they appeared invisible.
This isn't centering, but it does get your code away from the left edge of the
screen.

I even made it so that you can manually override the default 22 column offset.
All you need to do is set a variable in your `.vimrc` with a value from 1 to 22:

{% highlight vim %}
let g:lite_dfm_left_offset = 16
{% endhighlight %}


Aside from line numbers, the statusbar and ruler are also UI elements that
toggling LiteDFM hides. If your colorscheme doesn't hide those NonText `~`
characters that show up, this hides those too. Upon toggling off LiteDFM,
settings revert to what they were before.

This works for multiple windows as well. With a `vsplit` in fullscreen, it can
even pass off as being centered.

## Caveat

If you have a value of `none` for your `Normal` bg color, the plugin won't be
able to figure out what color to use to hide your UI elements.  To fix this, you
can [explicitly set the color to use](https://github.com/bilalq/lite-dfm#colors).
