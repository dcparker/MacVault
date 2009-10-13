# MacVault

MacVault is a simple, automated ruby-scripted git-based set-and-forget backup utility.

Here's how it works in a nutshell:

- Backups are done by symlinking .git in the backed-up location to a .git in the backup folder on the backup volume. Simple git commands record and store everything not ignored by a .gitignore file.
- The backup task is controlled by Mac's [launchctl](http://developer.apple.com/mac/library/documentation/Darwin/Reference/ManPages/man1/launchctl.1.html) / [launchd](http://developer.apple.com/macosx/launchd.html). You simply select a backup volume -- any volume that is mounted into /Volumes is allowed. This could be an external drive, a local secondary hard disk or a network location. The backup task will then run every 5 minutes whenever the selected backup volume is available.

Backups are stored and updated in a packed git repository on the backup volume. You can navigate there and easily unpack it (git checkout .) on the backup volume to look at files and restore them manually, or you can restore a file path back to where it came from.

## Requirements

- Mac OS X
- git
- ruby

## Install

    git clone git://github.com/dcparker/MacVault.git
    cd MacVault
    ./install

## Usage

To begin backing up a new file location:

    cd /path/to/location
    macvault --here --frequency 300  # set a frequency in seconds. Minimum is 300.

To view the backup history of a backup location:

    cd /path/to/location
    macvault --history

To restore latest copy of a backup:

    cd /Volumes/BACKUP_VOLUME/MacVault/SOME_BACKUP
    macvault --restore # macvault saves a new backup first in a timestamped branch.
    macvault --restore --fresh # macvault does NOT save a new backup first
    
To restore a version at a specific date/time:

    cd /Volumes/BACKUP_VOLUME/MacVault/SOME_BACKUP
    macvault --restore --time "YYYY-MM-DD HH:MM:SS" # << must be understood by Time.parse
    # Or you can use a ruby string that returns a time object. The days_and_times gem is included if available:
    macvault --restore --time "(1.hour + 6.minutes).ago"

Specify a time to restore from:

    macvault --restore --time "1.hour.ago"

Supply a specific path to restore:

    macvault --restore --time "1.hour.ago" /path/to/file/to/restore

If you supply a path to restore, and not a time, and that file doesn't currently exist, the backup will look into the history and restore the latest version of the file:

    macvault --restore /path/to/file/to/restore
