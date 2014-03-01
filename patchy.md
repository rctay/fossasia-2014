% Secret Lives of Patches
% Tay Ray Chuan rctay89@gmail.com
% 2014 Mar 1

---

![](images/GalleryChar_1900x900_JusticeLeague_52ab8e54d0a6f0.42170553.jpg)

<p style="font-size: small">Source: http://www.dccomics.com/characters/justice-league</p>

<!-- <div class="notes"> thing doesn't get converted to <aside> -->
<aside class="notes">
Superheroes are awesome. They have secret lives.
Your patches are awesome, they should have secret lives too.
Premise of talk: track your patches how you would track your source code.
// While people only see the final, polished patch, they may not see the 
// They may live a "double-life" that never sees the light of day - people only see the polished, accepted patch, 
</aside>

<!-- about myself, intro, pic of superhero -->

## Context <!-- assumptions -->

- source code tracked by Git  
  _though can apply to distributed version control_

- code contribution model: email-based patch model  
  _though can apply to Github pull requests as well_<!--
examples: Linux kernel, Git, LLVM
-->

## Patch Lifecycle

> * encounter bug/itch in open source project
> * hack away → patch
> * submit patch!
> * ...profit?

<div class="notes">
So, you spotted a bug in an open source project, or you want to add a feature. 
</div>

---

![](images/Bed_of_Roses.jpg_350x350.jpg)

<p style="font-size: small">Source: http://www.alibaba.com/product-detail/Bed-of-Roses_800016222.html</p>

<aside class="notes">
But we all know it's rarely that straightforward. (next)
</aside>

---

![](images/397px-Rose_Prickles.jpg)

<p style="font-size: small">Source: http://en.wikipedia.org/wiki/File:Rose_Prickles.jpg</p>

<!-- bed of roses - straightforward - get it? -->

<aside class="notes">
Other contributors to the project who reviewed your patch may have some comments, so you would have to make some to your patch.

After making the changes and re-submitting, sometimes your patch gets accepted, sometimes you need to make more changes. And so on - the patch may go through many more reviews and revisions.
</aside>

# Common approaches <!--
What some of us may do - I certainly did - is just to change the commits directly. One way to this is to use git-rebase --interactive.
(How many know what used git-rebase before)
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
Let's say we have 2 patches, a preparatory patch, and the actual patch. 
</div>

##

```bash
$ git rebase -i master
# (in editor)
pick 7e095ee clean up in prep for bugfix
e 060056c fix bug # s/pick/e/
```

<div class="notes">
What we do is to start git-rebase --interactive, then use the "edit" command, so that git-rebase stops at that commit for us to change it, eg. via git commit --amend
</div>

<!--
## manual squash

    $ git diff HEAD > mypatch.diff
    $ add patch text...
-->

## 

> * unable to annotate/describe changes
> * no history
<!--
Those of you who may be familiar with git may say, "but we have the reflog." But I feel the reflog doesn't count.
-->
> * _(no, reflog doesn't count)_

## Sounds familiar?

<div class="notes">
reasons for putting your patches under version control, are the same reasons for using version control for your code!
</div>

## A plan

<div class="notes">
We now have a rough idea on how to proceed.
Since version control operates on files, our patches needs to be in the form of files.
And it turns out that there are such patch tools.
TODO verify that quilt use predates git (first commit: 2005)

The first is guilt.
</div>

# guilt

## quilt for git

<div class="notes">
How many of you know what quilt is?
</div>

### quilt: grand daddy
<div class="notes">
quilt is the grand daddy of patch tools
allows you to "push" or apply patches on your working tree, pop patches, reorder, etc.
quilt in turn is based on Andrew Morton's scripts, which he used to manage Linux kernel patches. [1]

[1] http://lwn.net/Articles/13518/

back to guilt.
guilt supports the same operations as quilt, just that it has tight integration with git.
</div>

## quilt semantics in git

> - `QUILT_PATCHES` dir: `.git/patches/<branch>`
<!-- quilt directory is under the .git
series file, patch files are there
//small difference: patch and series stored at the same level
//(quilt is under .pc ?)
-->
> - `guilt new mypatch.diff`: create a new patch
> - `guilt refresh`: regenerate patch from working tree changes
> - `guilt push`: apply patch as a commit

## version control

```bash
$ guilt_dir() { p=$(git symbolic-ref --short HEAD); echo .git/patches/${p#guilt/}; }
$ alias ggit='git -C `guilt_dir`'
$ guilt refresh
$ ggit status
$ ggit commit -m 'check error code at delete() instead of init()' mypatch.diff
```

<div class="notes">
Now we have a quilt representation of patches, which are plain files, we can track changes to them.

we add an alias, ggit, to run git on the patch dir
${} is a bash-ism - sorry posix
</div>

---

```diff
commit e9f6a3810217c5b76cc0d5630f2d0cb352db19f0
Author: Tay Ray Chuan <rctay89@gmail.com>
Date:   Wed Feb 26 03:03:49 2014 +0800

    PR_PORT: drop port arg

    It is dport exactly.

diff --git a/mypatch.diff b/mypatch.diff
index 67c64f7..7b90665 100644
--- a/mypatch.diff
+++ b/mypatch.diff
@@ -89,7 +89,7 @@ index 26fb5c5..031644a 100644

  /**
 diff --git a/main.cpp b/main.cpp
-index 34b0789..8051dbe 100644
+index 34b0789..9885472 100644
 --- a/main.cpp
 +++ b/main.cpp
 @@ -17,6 +17,8 @@
@@ -156,13 +156,13 @@ index 34b0789..8051dbe 100644
  }

 +#ifdef MULTIIN_DEBUG
-+#define PR_PORT(prefix,port_inst,port,suffix) \
++#define PR_PORT(prefix,port_inst,suffix) \
 +      (fprintf(stderr, "%s%d (%d) %d->%d%s", \
 +              (prefix), \
 +              (port_inst)->linked_node->node->id, \
 +              (port_inst)->linked_node->node->type, \
 +              (port_inst)->sport, \
-+              (port), \
++              (port_inst)->dport, \
 +              (suffix)))
 +#endif
 +
```

<aside class="notes">
example of a log message
</aside>

## Review

- does what we want
- tad complicated

<div class="notes">
with guilt, we can track our patches, because guilt works on plain files
diff on diff, inception style - a bit complicated
</div>

# stgit

## Stacked Git

## `--ff`

> - based on quilt too
> - very rich porcelain

<div class="notes">
we're skipping ahead on stgit
</div>

# TopGit

## quilt - not

> - no diffs on diffs  
  _(just hack on working tree and commit)_
> - `tg patch`
> - magic files eg. `.topmsg` for patch message  
  _(patch text is available for tracking)_

<div class="notes">
topgit is different from the rest
totally breaks away from the quilt architecture - patch files, series file
Instead of thinking of patch sets/series within as part of topic branch, treat each individual patch as worthy of a topic branch
tg patch: generate patch
</div>

---

```bash
$ tg create t/cleanup
tg: Automatically marking dependency on master
tg: Creating t/cleanup base from master...
$ # hack on patch
$ git commit
```

<div class="notes">
so no inception, diff on diff
</div>

---

```bash
$ tg create t/bugfix
tg: Automatically marking dependency on t/cleanup
tg: Creating t/bugfix base from t/cleanup...
$ # hack on patch
$ git commit
```

<div class="notes">
patch ordering not via `series` file in quilt
tracked in a special file `.topdeps`
</div>

## Review

![I like!](images/280px-Facebook_like_thumb.png)

---

- works on `commit` in project; no inception-like diff-on-diff
- some magic unlike plain files in guilt, but ok

# Summary

## track patches

...like how you track code

> - annotation
> - collaboration  
  _(others can pick up where you left off)_

## Rule of Thumb

start tracking after one patch revision

<div class="notes">
if your patch doesn't get in after the review, because you need to make more changes, after 
</div>

## Future work

workflow for contributors; what about maintainers?