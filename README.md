# Paperless Backup
Backup [Paperless](https://github.com/danielquinn/paperless) data to a directory, maintaining a rolling history

This script is expected to be used as a cron job, with frequency depending on Paperless' rate of intake. If documents are frequently added, increasing cron frequency and/or number of backups to preserve is suitable. Safe storage of the backups is not within scope - its intended use is to dump the Paperless database into a safe directory, such as Dropbox or a network drive.

## To Do

* skip backup if nothing has been changed since the last one, preserving ability to roll back even after long periods of no paperwork being added (questionably worthwhile)
