require 'tmpdir'
require 'fileutils'
include FileUtils

class FileOperator
	
	def create_tmp(repo)
		dir = Dir.mktmpdir
		cp_r repo.path, dir
		dir
	end
	
	
	def dispose
		if @from and @from.path
			rm_rf @from.path
		end
		if @into and @into.path
			rm_rf @into.path
		end
	end
	
end