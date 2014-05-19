---
layout: post
title: "Understanding Promises in Angular"
date: 2014-05-18 22:00
comments: true
published: true
categories: JavaScript
---

Many of us were saved from callback hell and arrived in the Promised Land. Our
code was flattened, control logic flowed gracefully, and our errors were tamed.
But alas, there was still confusion to be found in this land of enlightenment.

For those of us who found ourselves working in Angular, the way the [$q Promise
library](https://code.angularjs.org/1.2.16/docs/api/ng/service/$q) works can be
a bit surprising. This post aims to help get rid of these surprises.

<!-- more -->

$rootScope Integration
----------------------
Usually, you'd expect `then` to be invoked immediately once the promise has been
resolved. That's not necessarily the case with $q promises. Anything that
executes on the next turn of the event loop needs to be wrapped in a
`$scope.$apply`, including promise resolutions.

If you're interested in learning more about `$scope.$apply` and Angular's digest
cycle, I recommend
[these](http://blog.bguiz.com/post/60397801810/digest-cycles-in-single-page-apps)
[links](http://www.benlesh.com/2013/08/angularjs-watch-digest-and-apply-oh-my.html)
[here](http://jimhoskins.com/2012/12/17/angularjs-and-apply.html).

Often times, this isn't something you need to really worry about, as services
like $http and $timeout take care of wrapping things within `$scope.$apply` on
their own. If you're manually creating promises for some reason, however, you'll
need to handle this yourself. When defining a service, the only scope you really
have a reference to is the `$rootScope`, so you'll need to use that there.

Here's a contrived example with `setTimeout` (in practice, you would just use
`$timeout`):

```javascript
angular.module('appName')
.factory('deferredDemo', function($rootScope, $q) {
  return {
    greet: function(name, delay) {
      var deferred = $q.defer()
      setTimeout(function() {
        // If you don't have this $rootScope.$apply here, it won't work!
        $rootScope.$apply(function() {
          if (name) {
            deferred.resolve('Hello, name!')
          } else {
            deferred.reject(new Error('No name specified for greeting'))
          }
        })
      }, delay)
      return deferred.promise
    }
  }
})
```

An area of particular importance here will be in your tests. You will often need
to include either `$rootScope.$apply` or `$rootScope.$digest` at the end of them
if you're testing things that return $q promises.

Rejecting Promises
------------------
In most promise libraries, you can simply throw an object to yield a rejection
to the next entry in the chain. If you throw when working with $q, your
application will actually end up throwing an error.

Instead, the $q service has a method called `reject` that takes a single
argument and returns a promise that is rejected with the value given. Instead
of throwing your errors, you simply return this rejected promise.

```javascript
promise.then(function(res) {
  if (!res.someValue) {
    return $q.reject(new Error('Property "someValue" not set'))
  }
  return res
})
.catch(function(err) {
  $log.error(err.message)
})
```

The $http Service
-------------
The [$http service](https://code.angularjs.org/1.2.16/docs/api/ng/service/$http)
returns HttpPromises. These have all the same methods as regular $q promises,
but with two additional methods: `success` and `error`. These exist as
convenience methods that spread out arguments to callbacks into multiple
arguments. There's no actual `spread` method in $q, so that's why they're used.

A common gotcha here is that `success` and `error` do **not** return new
promises based on the return value of the callback. Instead, they both simply
return the original promise from the $http call. This means you can chain
`success` and `error` if you're not doing anything too fancy, but you'll
probably want to stick to `then` and `catch` for more advanced use cases.


IE8 Support
-----------
If you can get away without needing to worry about IE8, then more power to you.
For everyone else, you need to be aware that usage of `.catch` and `.finally`
will throw errors in IE8, as it forbids the use of reserved words as properties.

Some other libraries have aliases such as `fail` and `lastly` available, but
you'll find nothing like that in Angular. Instead, you'll need to use bracket
notation for these methods.

Instead of:

```javascript
promise.then(function(res) {
  // do something
})
.catch(function(err) {
  // do something
})
.finally(function() {
  // do something
})
```

You'll write:

```javascript
promise.then(function(res) {
  // do something
})
['catch'](function(err) {
  // do something
})
['finally'](function() {
  // do something
})
```

Yeah, it looks funky. If you're using JSHint, you'll probably want to set the
`sub` option to `true` to supress warnings about not using dot notation.

Limited Extensibility
---------------------
The Promise prototype is pretty well encapsulated, so you can't really extend
it.

As for the $q and $http services themselves, you can extend them by creating
decorators. This sounds complicated, but all it really means is that you inject
`$provide` into a config block and call the `decorator` method. It takes a
service name and a callback to which it passes the original service instance.
With that, you can add new methods, override existing ones, or even replace
services entirely.  The service will be set to whatever you return from the
callback of `$provide.decorator`.

Here's an example of overriding `$q.all` to be a variadic function that accepts
multiple arguments.

```javascript
angular.module('appName')
.config(function($provide) {
  $provide.decorator('$q', function($delegate) {
    // The $delegate will be a reference to the $q service

    // Here we get reference to original $q.all method
    var originalAllMethod = $delegate.all

    // This is where we modify the definition of $q.all
    $delegate.all = function() {

      // If there are 0 or 1 arguments, just delegate to the original $q.all
      if (arguments.length <= 1) {
        return originalAllMethod(arguments[0])
      }

      // Otherwise, convert the arguments object to an array and pass that along
      return originalAllMethod(Array.prototype.slice.call(arguments))
    }

    // Return the modified $q service
    return $delegate
  })
})
```

Note that this works well for an example, but it's probably best not to actually
use this, since it doesn't do any flattening and the like.

Using Other Promise Libraries
-----------------------------
The focus of $q is to provide a byte-concious, minimal API for
dealing with async control flows. If you decide $q isn't doing enough, you can
always bring an a full-fledged promise library.

The important thing to remember is that you will need to take care of calling
`$scope.$apply` everywhere yourself. It's up to you to decide if that is an
acceptable tradeoff to make.
