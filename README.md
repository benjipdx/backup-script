Simple backup script that makes a tar archive of included directories and excludes excluded directories.

You can specify command to run before tar'ing the archive, so for instance I use it to dump postgres db's to a file, and then include that directory.

You can then edit root's crontab by:

```
sudo su root
crontab -e
```

And then insert the following:

`* */12 * * * /root/path/to/backup.sh >/dev/null 2>&1`

which will run the script every 12 hours


