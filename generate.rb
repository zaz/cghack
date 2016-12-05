#!/usr/bin/env ruby

exit unless system "git branch -D hack; git checkout --orphan hack"
system "git rm -rf --cached ."

DAY = 60 * 60 * 24

# Pixel darkness in hexadecimal. Try to keep the total value low (< ~1000).
IMAGE="\
                                                   
            88     88                              
             88   88                               
             8 8 8 8                               
             8  8  8                               
             8     8                               
            888   888                              "


image = IMAGE.split("\n").map { |r| r.split('') }
image = image.transpose.flatten.map { |d| d.to_i(16) }

day, month, year = Time.now.to_a[3..5]
time = Time.new(year - 1, month, day, 12)
time = time + (7 - time.wday) * DAY

commits = image.reduce(:+)
puts "WARNING: #{commits} is a lot of commits." if commits > 999
puts "Making #{commits} commits..."

for value in image
	value.times do
		system "git commit --allow-empty --allow-empty-message -m '' --date='#{time}' >/dev/null"
	end
	time = time + DAY
end
