require File.dirname(__FILE__)+'/file_operator'
require File.dirname(__FILE__)+'/repo'

class TmpRepo
	include RepoExtensions
	
	def initialize(repo)
		@revs = repo.revs
	end
	
	def path=(path)
		@path = path
	end
	def current_rev 
		@current_rev
	end
	def current_rev=(rev)
		@current_rev = rev
	end
	
	def checkout(rev)
		`hg revert `
	end
end

class Merger
	def initialize(from, into, file_operator)
		@from = TmpRepo.new from
		@into = TmpRepo.new into
		@file_operator = file_operator
	end
	
	def merge(from_rev, into_rev)
		begin
			@from.path = @file_operator.create_tmp @from
			@into.path = @file_operator.create_tmp @into
		ensure
			@file_operator.dispose
		end
	end
	
	private
	
end
