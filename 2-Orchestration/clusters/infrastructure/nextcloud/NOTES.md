# Nextcloud Notes

## File Upload

Most efficient to script uploading files directly to the pod w/ `kubectl cp` due to a few different constraints.

From host uploading photos
```
ls <list of files to upload> > list.txt
while read line; do kubectl cp -n nextcloud "$line" nextcloud-nextcloud-7c65874b9c-nq4sk:/var/www/html/data/path/to/dir ; done < list.txt 
```

from within the nextcloud pod (from within the '/var/www/html/data' directory):
```
runuser -u www-data -- php ./../occ files:scan --path="path/to/dir"
```