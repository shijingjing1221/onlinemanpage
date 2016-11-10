# man-to-github-pages
Convert man pages to HTML on github pages

[Live Demo](http://man.linuxtool.net)

### Snapshot
![snapshot](http://man.linuxtool.net/img/snapshot1.png)

### Usage
```sh
# checkon github pages branch
git checkout gh-pages


# build all man pages on your host ofrhel7 or higher  into HTML flies
sh build.sh rhel7/u3

# build all man pages on your host ofrhel6 or lower into HTML flies
sh build-rhel6.sh rhel6/u8

# commit to repo
git add rhel7/u3
git commit -m 'add man page for new version system'

# push to your github pages
git push
```

