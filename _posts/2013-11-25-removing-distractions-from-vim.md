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

Out of frustration, I came up with my own little solution. I wasn't really
trying to do anything complicated. What follows is a poor man's Distraction Free
Mode (DFM).

Just 2 lines in my `.vimrc` were needed.

<!--more-->

{% highlight vim %}
nnoremap <Leader>z :set numberwidth=10<CR>:hi LineNr ctermfg=237 ctermbg=237<CR>:set laststatus=0<CR>i<Esc>`^
nnoremap <Leader>Z :set numberwidth=4 <CR>:hi LineNr ctermfg=101 ctermbg=238<CR>:set laststatus=2<CR>i<Esc>`^
{% endhighlight %}

The first line is for entering DFM, and the second is for leaving it.

There is a lot going on there, so I'll explain it step by step.

If you are able to understand these lines as is, just be sure to change the
color values before putting them in your own vimrc.

## Before
<img src="/img/removing-distractions-from-vim/before.png" alt="Before" style="width:100%;max-width:732px;max-height:444px;" />

## After
<img src="/img/removing-distractions-from-vim/after.png" alt="After" style="width:100%;max-width:732px;max-height:444px;" />

<a name="breakdown"></a>
# The Breakdown

What I've done here is map some keystrokes to actions that you could normally do
manually.

## Mapping
{% highlight vim %}
nnoremap <Leader>z
nnoremap <Leader>Z
{% endhighlight %}

The `nnoremap` creates a normal mode mapping that is
[nonrecursive](http://learnvimscriptthehardway.stevelosh.com/chapters/05.html#nonrecursive-mapping).

`<Leader>` refers to the `\` character by default, but I've mapped mine to be
the `,` character. It is a [good idea](http://learnvimscriptthehardway.stevelosh.com/chapters/06.html) to use the `<Leader>` key in your
custom keymappings.

With this, `<Leader>z` enters DFM, and `<Leader>Z` exits.


## Centering
{% highlight vim %}
:set numberwidth=10<CR>
:set numberwidth=4 <CR>
{% endhighlight %}

Centering text turned out to be a bit challenging. However, there is something
natural that offsets text from the left: the line number column. By default,
it has a width of 4, and the largest it goes is 10.

This doesn't really center, but it gets it away from the left edge of the
screen.

`<CR>` refers to a Carriage Return (meaning the Enter/Return key).


## Hiding the line numbers
{% highlight vim %}
:hi LineNr ctermfg=237 ctermbg=237<CR>
:hi LineNr ctermfg=101 ctermbg=238<CR>
{% endhighlight %}

We need the line numbers to be there in order to make use of the offset they
provide, but we don't want them to be visible. The goal is to set the foreground
and background color to the same as the normal background, and then switch back
when leaving DFM. The values here are specific to the
[colorscheme I am using](https://github.com/junegunn/seoul256.vim).

Fortunately, getting the correct color values for yourself is very simple.

While in Vim, type `:hi Normal` and hit return. The value you see for ctermbg
is the one you want to replace both the numbers in the first line with.

For the second line, you want to replace the numbers with the values you see in
`:hi LineNr`.

If you use a GUI version of Vim like GVim or MacVim, use `guifg`/`guibg`
instead of the `cterm` equivalents.

## Hiding the status bar
{% highlight vim %}
:set laststatus=0<CR>
:set laststatus=2<CR>
{% endhighlight %}

This one isn't that complicated. The value of `laststatus` affects the status
bar as follows:

**0**: Always hide
<br>
**1**: Show only if there are at least two windows
<br>
**2**: Always show

If you don't normally keep your statusbar active at all times, you may want to
set the value in the second line there to `1`.

## Clearing messages
{% highlight vim %}
i<Esc>`^
i<Esc>`^
{% endhighlight %}

Executing the mappings we set up leaves a message showing the last command. The
simplest way I found to clear it was to have Vim change modes. `i` will take
Vim into insert mode, and `<Esc>` will take it back into Normal mode. However,
changing modes like that ends up moving the cursor back a position. The `` `^`` at
the end brings the cursor back where it should be.

<a name="thats_it"></a>
# That's it

There is almost certainly a more elegant way to accomplish all this, but this is
a relatively simple hack for the task. If anyone has suggestions for cleaning
this up, I'd love to hear them.

I am thinking that this could be refactored into a plugin that reads in your
colorscheme values and builds the correct mappings itself. Maybe even something
that toggles DFM, rather than having 2 separate mappings.

To recap:

{% highlight vim %}
nnoremap <Leader>z :set numberwidth=10<CR>:hi LineNr ctermfg=237 ctermbg=237<CR>:set laststatus=0<CR>i<Esc>`^
nnoremap <Leader>Z :set numberwidth=4 <CR>:hi LineNr ctermfg=101 ctermbg=238<CR>:set laststatus=2<CR>i<Esc>`^
{% endhighlight %}

If you're a tmux user, you may also want something that will let you toggle the
status bar there as well. Adding this line to your `.tmux.conf` should do the
trick:

```
bind-key z set -g status
```

