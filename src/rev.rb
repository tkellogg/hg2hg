
class Rev
	def initialize()
		@num = ""
		@hash = ""
		@parents = ""
		@author = ""
		@msg = ""
		@date = ""
		@branch = ""
		@children = Array.new
	end
	def num() @num end
	def hash() @hash end
	def parents() @parents end
	def author() @author end
	def msg() @msg end
	def date() @date end
	def branch() @branch end
	
	def parents= (parent)
		@parents = parent
	end
	def children
		@children
	end
	
	def to_s
		"Rev #{@num} (#{@hash})
parents: #{@parents}
author: #{@author}
comment: #{@msg}
date: #{@date}
branch: #{@branch}"
	end
	
	def ==(rev)
		@hash == rev.hash
	end
	
	def is_a_parent?(rev)
		ret = false
		return true if self == rev
		@parents.each{|r|
			if self != r
				ret = r.is_a_parent? rev
			else
				ret = true
				break
			end
		}
		ret
	end
end
