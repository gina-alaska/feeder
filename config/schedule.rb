# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

set :path, Dir.pwd
set :output, File.join(Dir.pwd, "log/cron_log.log")
set :environment, :development

# every 10.minutes do
#   command File.join(Dir.pwd,"script/rsync.sh")
# end

#every 10.minutes, :at => 5 do
#  runner 'Feed.import("webcam-uaf-barrow-seaice-images", "/san/tub/icemonkey/barrow_webcams/source/201203/")'
#end

every 1.day do
  runner "Feed.generate_animations"
end

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever
