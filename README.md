Simple backup script that makes a tar archive of included directories and excludes excluded directories.

You can then edit root's crontab by:

```
sudo su root
crontab -e
```

And then insert the following:

`* */12 * * * /root/path/to/backup.sh >/dev/null 2>&1`

which will run the script every 12 hours


