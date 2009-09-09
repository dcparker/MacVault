#!/usr/bin/env ruby

Dir.chdir("/Volumes/Pig Will/Backups.backupdb/Daniel Parker’s MacBook")

backups = Dir.glob("/Volumes/Pig Will/Backups.backupdb/Daniel Parker’s MacBook/*").select {|b| b =~ /\d{4}/}
backups.sort.reverse.each do |backup|
  # puts "ruby ~/Desktop/CombinedRestore.rb #{backup} /Volumes/Pig\\ Will/Backups-combined/"
  if File.exists?("#{backup}/.done")
    puts "Skipping #{backup.split(/\//).last}"
  else
    puts "Combining #{backup.split(/\//).last}"
    system "ruby ~/Desktop/CombinedRestore.rb \"#{backup}\" \"/Volumes/Pig Will/Backups-combined/\""
  end
end
