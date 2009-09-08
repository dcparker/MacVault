# MacVault

## Description

MacVault is a ruby-scripted git-based backup utility.

## Requirements

- Unix/BSD-style OS
- git
- ruby

## Install

git clone git://github.com/dcparker/MacVault.git
cd MacVault
sudo ln bin/macvault /usr/local/bin

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
