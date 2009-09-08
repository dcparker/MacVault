# MacVault

MacVault is a simple, automated ruby-scripted git-based set-and-forget backup utility.

Here's how it works in a nutshell:

- Backups are done by symlinking .git in the backed-up location to a .git in the backup folder on the backup volume. Simple git commands record and store everything not ignored by a .gitignore file.
- The backup task is controlled by Mac's [launchctl](http://developer.apple.com/mac/library/documentation/Darwin/Reference/ManPages/man1/launchctl.1.html) / [launchd](http://developer.apple.com/macosx/launchd.html). Backups are performed every 5 minutes when a relevant directory is present. You will usually place this on an external drive, a local secondary hard disk or a network location.
- Backup tasks backup whatever backups are available. You may have more than one backup location if you want, and they can duplicate backups or hold different portions of your backups.

## Requirements

- Mac OS X
- git
- ruby

## Install

    git clone git://github.com/dcparker/MacVault.git
    sudo ln MacVault/bin/macvault /usr/local/bin
    sudo ln MacVault/bin/macvault-task /usr/local/bin
    rm -rf MacVault

## Usage

To begin backing up a new file location:

    cd /path/to/location
    macvault --here

To view the backup history of a backup location:

    cd /path/to/location
    macvault --history

To restore latest copy of a backup:

    cd /Volumes/BACKUP_VOLUME/MacVault/SOME_BACKUP
    macvault --restore
    
To restore a version at a current date:

    cd /Volumes/BACKUP_VOLUME/MacVault/SOME_BACKUP
    macvault --restore "YYYY-MM-DD HH:MM:SS"

Specify a time to restore from:

    macvault --restore --time "1 hour ago"

Supply a specific path to restore:

    macvault --restore --time "1 hour ago" /path/to/file/to/restore

If you supply a path to restore, and not a time, and that file doesn't currently exist, the backup will look into the history and restore the latest version of the file:

    macvault --restore /path/to/file/to/restore
