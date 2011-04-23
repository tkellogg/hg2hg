
def check_params()
	usage if ARGV.length < 2
	usage if not Dir.exists? "#{ARGV[0]}/.hg" or not Dir.exists? "#{ARGV[1]}/.hg"
	$from = Repo.new ARGV[0]
	$into = Repo.new ARGV[1]
	if ARGV.length > 2
		$starting_at = ARGV[2]
	end
end

def usage() 
	puts "Merges one mecurial repository into another.
Usage:
	hg2hg <from-repo-path> <into-repo-path> [ <starting-rev> ]
	
from-repo-path 
	The path of the repository that you are trying to get rid of 
	
into-repo-path
	The path of the repository that you are merging into.
	
starting-rev
	The revision from <into-repo-path> which is the last common commit.
	
You are receiving this message because the arguments you used are invalid"
	exit(1)
end


class Repo
	def initialize(path)
		@path = path
		init_revs
	end
	
	def init_revs
		Dir.chdir @path
		# this would normally be a terrible format to read, but it's not a bad
		# format for parsing strings
		text = `hg log --template "::::num {rev}\\n::::hash {node}\\n::::parents {parents}\\n::::author {author}\\n::::msg {desc}\\n::::date {date}\\n::::branch {branches}\\n::::end\\n"`
		@revs = []
		rev = Rev.new()
		text.each_line { |ln|
			if ln.start_with? '::::end'
				cur = nil
				@revs.push rev
				rev = Rev.new
			elsif ln.start_with? '::::num'
				rev.num << ln[8..-1]
				cur = rev.num
			elsif ln.start_with? '::::hash'
				rev.hash << ln[9..-1]
				cur = rev.num
			elsif ln.start_with? '::::parents'
				rev.parents << ln[9..-1]
				cur = rev.num
			elsif ln.start_with? '::::author'
				rev.author << ln[9..-1]
				cur = rev.num
			elsif ln.start_with? '::::msg'
				rev.msg << ln[9..-1]
				cur = rev.num
			elsif ln.start_with? '::::date'
				rev.date << ln[9..-1]
				cur = rev.num
			elsif ln.start_with? '::::branch'
				rev.branch << ln[9..-1]
				cur = rev.num
			elsif cur != nil
				cur << ln
			end
		}
		# oh yeah, add that last one in also
		@revs.push rev
	end
	
	def path
		@path
	end
end

class Rev
	def initialize()
		@num = ""
		@hash = ""
		@parents = ""
		@author = ""
		@msg = ""
		@date = ""
		@branch = ""
	end
	def num() @num end
	def hash() @hash end
	def parents() @parents end
	def author() @author end
	def msg() @msg end
	def date() @date end
	def branch() @branch end
end

check_params
Dir.chdir $from.path
