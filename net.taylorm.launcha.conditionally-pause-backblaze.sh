#!/bin/bash

set -e

mkdir -p $HOME/Library/Logs/net.taylorm.launcha.conditionally-pause-backblaze
mkdir -p "$HOME/Library/Application Support/net.taylorm.launcha.conditionally-pause-backblaze"

cat <<__eot__ >"$HOME/Library/Application Support/net.taylorm.launcha.conditionally-pause-backblaze/pause-backup"
#!/bin/sh
/usr/bin/logger -is "Starting '$HOME/Library/Application Support/net.taylorm.launcha.conditionally-pause-backblaze/pause-backup' from $HOME/Library/LaunchAgents/net.taylorm.launcha.conditionally-pause-backblaze.plist"
~/pdev/taylormonacelli/conditionally-pause-backblaze/pause-backup
__eot__

cat <<__eot__ >$HOME/Library/LaunchAgents/net.taylorm.launcha.conditionally-pause-backblaze.plist
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
  <dict>

    <key>Label</key>
    <string>net.taylorm.launcha.conditionally-pause-backblaze</string>

    <key>LowPriorityIO</key>
    <true/>

    <key>Program</key>
    <string>$HOME/Library/Application Support/net.taylorm.launcha.conditionally-pause-backblaze/pause-backup</string>

    <!-- great for debug since it runs as soon as we do launchctl load -->
    <key>RunAtLoad</key>
    <true/>

    <key>StandardErrorPath</key>
    <string>$HOME/Library/Logs/net.taylorm.launcha.conditionally-pause-backblaze/net.taylorm.launcha.conditionally-pause-backblaze.err</string>
    <key>StandardOutPath</key>
    <string>$HOME/Library/Logs/net.taylorm.launcha.conditionally-pause-backblaze/net.taylorm.launcha.conditionally-pause-backblaze.out</string>

    <!-- lowest priority -->
    <key>Nice</key>
    <integer>19</integer>

    <key>StartInterval</key>
    <integer>3600</integer>

  </dict>
</plist>
__eot__
chmod +x "$HOME/Library/Application Support/net.taylorm.launcha.conditionally-pause-backblaze/pause-backup"

# reminders for how to manipulate plsits and launchd
: <<COMMENTBLOCK
# debug
launchctl unload $HOME/Library/LaunchAgents/net.taylorm.launcha.conditionally-pause-backblaze.plist
launchctl load $HOME/Library/LaunchAgents/net.taylorm.launcha.conditionally-pause-backblaze.plist
launchctl list net.taylorm.launcha.conditionally-pause-backblaze
launchctl list | grep net.taylorm.launcha.conditionally-pause-backblaze
cat $HOME/Library/Logs/net.taylorm.launcha.conditionally-pause-backblaze/net.taylorm.launcha.conditionally-pause-backblaze.{err,out}
ls -la $HOME/Library/Logs/net.taylorm.launcha.conditionally-pause-backblaze/*
ls -la $HOME/Library/LaunchAgents/net.taylorm.launcha.conditionally-pause-backblaze.plist
launchctl unload $HOME/Library/LaunchAgents/net.taylorm.launcha.conditionally-pause-backblaze.plist
cat "$HOME/Library/Application Support/net.taylorm.launcha.conditionally-pause-backblaze/pause-backup"
COMMENTBLOCK

# reminder for how to cleanup/abort this plist
: <<ABORT_UNLOAD_AND_CLEANUP
launchctl unload $HOME/Library/LaunchAgents/net.taylorm.launcha.conditionally-pause-backblaze.plist
rm -f $HOME/Library/LaunchAgents/net.taylorm.launcha.conditionally-pause-backblaze.plist
rm -rf "$HOME/Library/Logs/net.taylorm.launcha.conditionally-pause-backblaze"
rm -rf "$HOME/Library/Application Support/net.taylorm.launcha.conditionally-pause-backblaze"
ABORT_UNLOAD_AND_CLEANUP
