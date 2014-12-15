Simple backup script that makes a tar archive of included directories and excludes excluded directories.

You can specify command to run before tar'ing the archive, so for instance I use it to dump postgres db's to a file, and then include that directory.

You can then edit root's crontab by:

```
sudo su root
crontab -e
```

And then insert the following:

```
* 2 * * * /root/bin/backup.bash > /var/log/backup.log 2>&1
* 4 2 * * /root/bin/prune.sh > /dev/null 2>&1
```

which will run the script daily at 2am, and the prune script at 4am on the second of the month


