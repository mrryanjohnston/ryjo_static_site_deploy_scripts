# ryjo's Static Site Deploy Scripts

Scripts I use to deploy [my personal website](https://ryjo.codes). You can use
them, too.

## install.sh

This script is used to create symlinks in `/usr/local/bin` to `publish.sh`,
`init_rss_feed.sh`, `add_item_to_rss_feed.sh` and `ryjo.sh`.
It is not required to use this script, so don't worry if you don't want to!
Use it like this:

```bash
./install.sh
```

## add_item_to_rss_feed.sh

This script adds items to your RSS feed. Use it like this:

```bash
add_item_to_rss_feed.sh articles/foo.html
# To show everything this command can do:
add_item_to_rss_feed.sh -h
```

## check_aws.sh

This script is used to make sure aws-cli works correctly. It'll give some good
instructions on how to get your credentials from AWS to start using the
`publish.sh` script. Use it like this:

```bash
./check_aws.sh
```
## init_rss_feed.sh

This script creates an RSS feed. Use it like this:

```bash
init_rss_feed.sh
# To show everything this command can do:
init_rss_feed.sh -h
```


## publish.sh

This script is used to publish files to s3. Use it like this:

```bash
./publish.sh index.html articles/foo.html

# Or, when you're in the directory of the site you want to publish:
../ryjo_static_site_deploy_scripts/publish.sh index.html articles/foo.html

# Or, if you've run install.sh:
publish.sh index.html articles/foo.html

# You can get a full explanation of the command by using -h:
publish.sh -h

# Want to just publish your entire directory?
find * -type f | xargs publish.sh
```

## ryjo.sh

This script sources `.ryjo.conf` in your current directory
and attempts to run the next argument you pass it as a function.
The idea behind this is to provide a way to run function defined
in `.ryjo.conf` as commonly run scripts.

Imagine your `.ryjo.conf` looks like this:

```bash
RYJO_RSS_FEED_FILE="feed.rss"
publish_article () {
  if add_item_to_rss_feed.sh $1
  then
    publish.sh $1 $RYJO_RSS_FEED_FILE
  else
    echo "There was a problem adding $1 to the rss feed. Publishing canceled."
    exit 1;
  fi
}
```

You could quickly update your rss feed by adding the article to its list of items,
then publish your article and feed:

```bash
./ryjo.sh publish_article articles/foo.html

# Or, when you're in the directory of the site you want to publish:
../ryjo_static_site_deploy_scripts/ryjo.sh publish_article articles/foo.html

# Or, if you've run install.sh:
ryjo.sh publish_article articles/foo.html
```

## uninstall.sh

This script is used to remove the symlinks in `/usr/local/bin`
created by running the `install.sh` script. Be warned: all it does is
`unlink`. It does _not_ check to make sure that the `install.sh` script 
was the script that originally linked it. Use it like this:

```
./uninstall.sh
```
