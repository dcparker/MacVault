#!/usr/bin/env ruby
require 'ftools'

# Crawl ALL directories, and move all files to corresponding location at destination.
# Don't move file if same file already exists and has a later timestamp.

source_location = ARGV[0].to_s.gsub(/\/$/,'')
source_location_length = source_location.length
target_location = ARGV[1].to_s.gsub(/\/$/,'')
current_location = Dir.pwd

class WalkDirTree
  def each_file(&block)
    raise ArgumentError unless block_given?
    @each_file = block
  end

  def walk!(dir='.')
    current_directory = Dir.pwd

    tree = {'' => [dir]}
    begin
      at = tree.keys.sort {|a,b| a.length <=> b.length}.last
      start = at == '' ? tree[at].shift : at+'/'+tree[at].shift
      # puts "Starting at #{start}"
      files = []
      dirs = []
      Dir.glob("#{start}/*").select {|f| !File.symlink?(f)}.each do |fn|
        (File.directory?(fn) ? dirs : files) << fn
      end
      tree[start] = dirs.collect {|d| d[d.rindex('/')+1..-1]} unless dirs.empty?
      # puts "Directories: #{dirs.collect {|d| d[d.rindex('/')+1..-1]}.inspect}"
      # puts "Files: #{files.inspect}"
      files.each do |f|
        @each_file.call(f)
      end if @each_file
      Dir.rmdir(start) rescue nil if files.empty? && dirs.empty?
      tree.delete(at) if tree[at].empty?
    end until tree.keys.empty?
  end
end

walker = WalkDirTree.new
total_count = 0
moved_count = 0
$stdout << "\n"
walker.each_file do |filename|
  # for each file, if it does not exist in the destination_location, then mv it over there.
  relative = filename[source_location_length+1..-1]
  relative_path = relative[0..relative.rindex('/')-1]
  # puts relative
  # puts relative_path
  total_count += 1
  unless File.exists?(target_location+'/'+relative)
    begin
      File.makedirs("#{target_location}/#{relative_path}")
      File.move(filename, "#{target_location}/#{relative}")
    rescue => e
      # warn "Error: #{e.inspect} >> #{e.backtrace[0..5].join("\n")}"
    end
    moved_count += 1
  end
  $stdout << "\r#{total_count} files, #{moved_count} moved"
  $stdout.flush if total_count % 10 == 0
end

walker.walk!(source_location)
