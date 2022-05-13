# packtest

The shell script in this repo is meant to measure the cost of large files with
small diffs over lots of commits.

Experiment: create 500 vesions of a file that's basically $(seq $version $((
$version + 1000000))); which is about 7 megabytes.  Initial creation of the
data was large and inefficient:

```bash
$ head seq.txt -n1; du -hs .git
500
1.1G    .git
```

`git gc` brings it back to sensiblity:

```bash
$ git gc
Enumerating objects: 1500, done.
Counting objects: 100% (1500/1500), done.
Delta compression using up to 4 threads
Compressing objects: 100% (1000/1000), done.
Writing objects: 100% (1500/1500), done.
Total 1500 (delta 497), reused 0 (delta 0), pack-reused 0
$ head seq.txt -n1; du -hs .git
500
8.7M    .git
```

Pushing after `gc` is efficient:

```bash
$ git push -vvvv -u origin main
Pushing to github.com:frioux/packtest.git
Enumerating objects: 1500, done.
Counting objects: 100% (1500/1500), done.
Delta compression using up to 4 threads
Compressing objects: 100% (503/503), done.
Writing objects: 100% (1500/1500), 8.25 MiB | 1.36 MiB/s, done.
Total 1500 (delta 497), reused 1500 (delta 497), pack-reused 0
remote: Resolving deltas: 100% (497/497), done.
To github.com:frioux/packtest.git
 * [new branch]      main -> main
Branch 'main' set up to track remote branch 'main' from 'origin'.
updating local tracking ref 'refs/remotes/origin/main'
```

If you push before a `gc` your local storage will be inefficient but the data over the wire is still small:

```bash
¢ git push -vvvv -u origin main
Pushing to github.com:frioux/packtest.git
Enumerating objects: 1500, done.
Counting objects: 100% (1500/1500), done.
Delta compression using up to 4 threads
Compressing objects: 100% (1000/1000), done.
Writing objects: 100% (1500/1500), 8.25 MiB | 1.38 MiB/s, done.
Total 1500 (delta 496), reused 0 (delta 0), pack-reused 0
remote: Resolving deltas: 100% (496/496), done.
To github.com:frioux/packtest.git
 * [new branch]      main -> main
Branch 'main' set up to track remote branch 'main' from 'origin'.
updating local tracking ref 'refs/remotes/origin/main'
```

Cloning the above repo is efficient:

```bash
$ git clone https://github.com/frioux/packtest packtest2
Cloning into 'packtest2'...
remote: Enumerating objects: 1500, done.
remote: Counting objects: 100% (1500/1500), done.
remote: Compressing objects: 100% (504/504), done.
remote: Total 1500 (delta 496), reused 1500 (delta 496), pack-reused 0
Receiving objects: 100% (1500/1500), 8.25 MiB | 3.49 MiB/s, done.
Resolving deltas: 100% (496/496), done.
$ du -hs packtest2/.git
8.4M    packtest2/.git
```
