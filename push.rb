#!/usr/bin/env ruby

# Script to deploy to itch. Pushes each ./export/, parsing out the platform
# channel. Uses version from ./data/metadata.json.
#
# USAGE:
# ruby push.rb
# OR
# ./push.rb
# OR
# just push

require "fileutils"
require "json"
DRY_RUN = ARGV.include?('--dry-run')

METADATA = JSON.parse(File.read("data/metadata.json"))
VER = METADATA["version"]
ITCH = METADATA["itch"]
if ITCH.nil?
  abort("ERROR: You must set \"itch\" key in data/metadata.json to deploy to itch; format: username/project-slug")
end

def butler_push(file, channel)
  butler_cmd = "butler push --userversion=#{VER} #{file} #{ITCH}:#{channel}"

  if DRY_RUN
    puts "[DRY RUN] pushing to itch: #{butler_cmd}"
  else
    system(butler_cmd)
  end
end

if DRY_RUN
  puts "[DRY RUN] cleaning export/*"
else
  FileUtils.rm_r(Dir.glob("export/*"))
end
puts `usagi export`

Dir.glob("export/*") do |file|
  channel = nil

  if file.end_with?(".usagi")
    channel = "usagi"
  else
    file_parts = file.split("/").last.split(".").first.split("-")

    if file_parts.last == "aarch64"
      channel = file_parts[-2] + "-aarch64"
    else
      channel = file_parts[-1]
    end
  end

  butler_push(file, channel)
end
