---
layout: post
title: "Working with Laravel on OSX"
date: 2012-12-31 02:00
comments: true
published: true
categories: [PHP, Laravel, OSX, Guide]
---

In case you haven't heard, PHP is becoming cool again. I say this as a joke, but
there's a ring of truth to it. With the advent of things like Composer, PSRs,
and improvements to the core of PHP, things are beginning to look bright for PHP
once again.

Among the shiny new things is a framework called [Laravel](http://laravel.com).
It's described as a framework for web artisans, and that's precisely what it is.
Before you can start developing in Laravel on OSX, however, you need to make
sure you have all the little bits and pieces you need. This is just a little
guide to help you blitz through the process. The assumptions I make are that
you have:

* A somewhat recent version of OSX
* Installed command-line tools from Xcode
* Installed [Brew](http://mxcl.github.com/homebrew/)
* At least some level of comfort with the command-line

<!--more-->


## Setting up Apache ##

If you already have Apache set up, you can skip this section. I'm writing this
guide under the assumption you're not running MAMP. I've never used it myself,
so I can't guarantee this guide will work for you if you are.

OSX already comes with the Apache web-server and PHP installed. However, the
default configuration needs some adjustment. We first need to make sure that the
modules for PHP and rewrite are enabled. Open a terminal, and run these
commands:

    sudo -s
    cp /etc/apache2/httpd.conf /etc/apache2/httpd.conf.bak
    vim /etc/apache2/httpd.conf

Replace the `vim` in the last command  with `nano` if you've never used vim
before. If you're using nano, the `^` you see by all the instructions means the
`Ctrl` key.

Once you've done that, your Apache configuration should be open for editing.
Find the lines that look something like these two:

`LoadModule php5_module libexec/apache2/libphp5.so`

`LoadModule rewrite_module libexec/apache2/mod_rewrite.so `

Now just uncomment these two lines (remove any `#` character that's in front of
them) and then save & quit from your text editor. Once you've done that, just
restart apache:

    apachectl restart


## Configuring Virtual Hosts ##
You can skip this section if you have your own way of configuring vhosts as
well. If you're unfamiliar with them, virtual hosts are a nice way of setting up
and pairing multiple domains and projects. This is optional, but adds some
niceties.

You could configure these manually, or just let a nice little tool called
virtualhost.sh do all the work for you.

Make sure you're not root right now, and run this command in a terminal:

    brew install virtualhost.sh

Once you've done that, run:

    virtualhost.sh your_project_name_here.dev

Answer the yes/no prompts (and ignore any updates to virtualhost.sh that might
exist for now). In your home folder now, there will be a `Sites` folder along
with your\_project\_name\_here.dev as a subdirectory in there. Now if you open
up a browser and go to `http://your_project_name_here.dev`, you'll see it
displaying the contents of the index.html file there.

This auto-generated virtualhost file would be fine for most projects, but 
Laravel uses a different DocumentRoot by default for some extra security. Run 
`sudo vim /etc/apache2/virtualhosts/your_project_name_here.dev` and add 
`/public` to the end of the value of the DocumentRoot. After you save and quit,
run `sudo apachectl restart`.

You can create virtualhosts for other projects the same way. Something to note:
You might start getting apache errors if the `logs` folder in one of these
virtualhosts ever gets deleted. If you run into this problem, you can either
remove references to these logs in the files in `/etc/apache2/virtualhosts`, or
just recreate the directory. Once you do one these things, be sure to restart
apache by running `sudo apachectl restart`.


## Installing mcrypt ##

Laravel makes use of an encryption module called mcrypt that is not installed by
default on OSX. You can check if you have the mcrpyt module in PHP by running 
this command in a terminal:

    php -m | grep mcrypt

If you got `mcrypt` as the output of this, you're all set. Otherwise, there's a
bit of work to be done. Run these commands:

    brew update
    brew install autoconf automake
    brew install mcrypt

We now have mcrypt installed, but we still need to get PHP set up to work with
it. First, you'll need to find out what version of PHP you have. 5.3 is required
for Laravel, and if you don't have at least that, you'll need to update your PHP
installation. That's beyond the scope of this guide, so you're on your own
there if that turns out to be the case.

    php --version

Once you have the version noted, download the source code of the corresponding
version from [this link](https://github.com/php/php-src/tags). Unzip it, and
then cd into the folder where you did so. Once you've done that, run these
commands:

    cd ext/mcrypt
    phpize
    ./configure
    make
    sudo make install

Now we just need to update PHP's configuration to make use of the mcrpyt
extension. If you don't have the file `/etc/php.ini`, you should at least have
something called `/etc/php.ini.default`. Run these commands:

    sudo -s
    cp /etc/php.ini.default /etc/php.ini
    vim /etc/php.ini

Now just add this line somewhere in the file, and then save & quit:

    extension=mcrypt.so

All that's left is to restart Apache, and we're all done:

    apachectl restart


## Starting Your First Laravel Project ##

Now that all the litle configuration details are taken care of, we can move on
to the stuff you actually care about. At this point, you can pretty much follow
the instructions found on the
[Laravel docs](http://laravel.com/docs/install#installation). One thing that
people often forget to do is to make their `storage/views` directory writable.
You can do that by moving into your project folder and running:

    chmod -R 777 storage/views

Follow the rest of the instructions in the docs, and you should be good to go.
Laravel is a really amazing framework, and it's certainly worth the effort. Best
of luck!
