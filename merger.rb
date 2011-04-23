require 'tmpdir'
require 'fileutils'
require File.dirname(__FILE__)+'/repo'
include FileUtils

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
	def initialize(from, into)
		@from = TmpRepo.new from
		@into = TmpRepo.new into
	end
	
	def merge(from_rev, into_rev)
		@from.path = create_tmp @from
		@into.path = create_tmp @into
		
	end
	
	def dispose
		rm_rf @from_path
		rm_rf @into_path
	end
	
	private
	def create_tmp(repo)
		dir = Dir.mktmpdir
		cp_r repo.path, dir
		dir
	end
end
