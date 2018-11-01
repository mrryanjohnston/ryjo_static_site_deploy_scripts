# ryjo's Static Site Deploy Scripts

Scripts I use to deploy [my personal website](https://ryjo.codes). You can use
them, too.

## install.sh

This script is used to create a symlink for `publish.sh` in `/usr/local/bin`. 
It is not required to use this script, so don't worry if you don't want to!
Use it like this:

```
./install.sh
```

## check_aws.sh

This script is used to make sure aws-cli works correctly. It is run as part of
`publish.sh`, so you don't need to run it separately if you do not want to.
It'll give some good instructions on how to get your credentials from AWS to
start using the `publish.sh` script. Use it like this:

```
./check_aws.sh
```

## publish.sh

This script is used to publish files to s3. Use it like this:

```
./publish.sh index.html articles/foo.html
# Or, when you're in the directory of the site you want to publish:
../ryjo_static_site_deploy_scripts/publish.sh index.html articles/foo.html
# Or, if you've run install.sh:
publish.sh index.html articles/foo.html
# You can get a full explanation of the command by using -h:
publish.sh -h
```

## uninstall.sh

This script is used to remove the symlink for `publish.sh` in `/usr/local/bin`
created by running the `install.sh` script. Be warned: all it does is
`sudo unlink /usr/local/bin/publish.sh`. It does _not_ check to make sure
that the `install.sh` script was the script that originally linked it.
Use it like this:

```
./uninstall.sh
```

