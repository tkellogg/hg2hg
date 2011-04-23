
class Repo
	def initialize(path)
		@path = path
		init_revs
		finalize_revs
	end
	
	def init_revs
		Dir.chdir @path
		# this would normally be a terrible format to read, but it's not a bad
		# format for parsing strings. Also, I suppose there is a maximum number
		# of commits that this guy will recognize (but it's a lot)
		text = `hg log -l 9999999999 --template "::::num {rev}\\n::::hash {node}\\n::::parents {parents}\\n::::author {author}\\n::::msg {desc}\\n::::date {date|isodatesec}\\n::::branch {branches}\\n::::end\\n"`
		@revs = Array.new
		rev = Rev.new()
		text.each_line { |ln|
			if ln.start_with? '::::end'
				cur = nil
				@revs.unshift rev
				rev = Rev.new
			elsif ln.start_with? '::::num'
				rev.num << ln[8..-1].strip
				cur = rev.num
			elsif ln.start_with? '::::hash'
				rev.hash << ln[9..-1].strip
				cur = rev.num
			elsif ln.start_with? '::::parents'
				rev.parents << ln[12..-1].strip
				cur = rev.num
			elsif ln.start_with? '::::author'
				rev.author << ln[11..-1].strip
				cur = rev.num
			elsif ln.start_with? '::::msg'
				rev.msg << ln[8..-1].strip
				cur = rev.num
			elsif ln.start_with? '::::date'
				rev.date << ln[9..-1].strip
				cur = rev.num
			elsif ln.start_with? '::::branch'
				rev.branch << ln[11..-1].strip
				cur = rev.num
			elsif cur != nil
				cur << ln
			end
		}
		# oh yeah, add that last one in also
		@revs.push rev
	end
	
	def finalize_revs
		last = @revs.first
		@revs[1..-1].each { |r|
			if !r.parents
				# if the {parents} field was blank, the last rev was
				# the parent
				r.parents = last
			else
				revs = Array.new
				r.parents.scan(/(\d+):([a-f0-9]+)/) { |m|
					hash = m[1]
					rev_list = @revs.select { |x| x.hash.start_with? hash }
					if rev_list.length > 0
						revs << rev_list.first
					end
				}
				r.parents = revs
			end
			last = r
		}
	end
	
	def path
		@path
	end
	
	def revs
		@revs
	end
end
