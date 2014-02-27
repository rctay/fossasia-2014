% Secret Lives of Patches
% Tay Ray Chuan
% 2014 Mar 1

<!--
Superheroes are awesome. They have secret lives.
Your patches are awesome, they should have secret lives too.
Premise of talk: track your patches how you would track your source code.
// While people only see the final, polished patch, they may not see the 
// They may live a "double-life" that never sees the light of day - people only see the polished, accepted patch, 
-->

# About <!-- about myself -->

## one

## two

## Patch Lifecycle

> * encounter bug/itch in open source project
> * hack away → patch
> * submit patch!
> * ...profit?

<div class="notes">
So, you spotted a bug in an open source project, or you want to add a feature. 
</div>

## zzz

<div class="notes">
But we all know it's rarely that straightforward.
Other contributors to the project who reviewed your patch may have some comments, so you would have to make some to your patch.

After making the changes and re-submitting, sometimes your patch gets accepted, sometimes you need to make more changes. And so on - the patch may go through many more reviews and revisions.
</div>

# Common approaches <!--
What some of us may do - I certainly did - is just to change the commits directly. One way to this is to use git-rebase.
-->

## git-rebase

##

```bash
$ git log -5
060056c fix bug (Tay Ray Chuan, Sat Feb 22 02:17:06 2014 +0800)
7e095ee clean up in prep for bugfix (Tay Ray Chuan, Sat Feb 22 01:09:2014 +0800)
...
```

<div class="notes">
Let's say we have 2 patches, a preparatory patch, and a 
</div>

##

```bash
$ git rebase -i master
# (in editor)
pick 7e095ee clean up in prep for bugfix
e 060056c fix bug # s/pick/e/
```

<!--
## manual squash

    $ git diff HEAD > mypatch.diff
    $ add patch text...
-->

## 

> * unable to annotate/describe changes
> * no history
> * _(no, reflog doesn't count)_

<div class="notes">
Those of you who may be familiar with git may say, "but we have the reflog." But I feel the reflog counts.
</div>

## Sounds familiar?

<div class="notes">
reasons for putting your patches under version control, are the same reasons for using version control for your code!
</div>

# Patch management

# Tools

## guilt

git + quilt

<div class="notes">
No survey of patch management software can begin without mentioning quilt. Quilt allows you to 

Quilt in turn is based on Andrew Morton's scripts, which he used to manage Linux kernel patches. []

- &lt;2002

[] http://lwn.net/Articles/13518/
</div>

##

    $ find
    ./patches/bugfix.diff
    ./patches/cleanup.diff
    ./series

    $ cat series
    cleanup.diff
    bugfix.diff

<div class="notes">
This is what a typical quilt layout looks like. We have a `patches` directory to collect the patches, and a `series` file to specify the order in which they should be applied.
</div>


# stgit (Stacked Git)

# TopGit

## Throws out Quilt entirely

<div class="notes">
Instead of thinking of patch sets/series within as part of topic branch, treat each individual patch as worthy of a topic branch
</div>
