require File.dirname(__FILE__)+'/repo'
require File.dirname(__FILE__)+'/rev'

def check_params()
	usage if ARGV.length < 2
	usage if not Dir.exists? "#{ARGV[0]}/.hg" or not Dir.exists? "#{ARGV[1]}/.hg"
	$from = Repo.new ARGV[0]
	$into = Repo.new ARGV[1]
	if ARGV.length > 2
		$starting_at = ARGV[2]
	else
		$starting_at = nil
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

def same_revs?(a, b)
	# dates seem to be the only thing that stays the same during a migration
	# from TFS to SVN to Git to Mecurial
	a.date == b.date
end

def find_rev(repo, rev)
	all = repo.revs.select {|x| same_revs? x, rev}
	if all.length > 1
		puts "ugh..we found #{all.length} possible revs"
	end
	all.first
end

check_params
if $starting_at
	revs = $into.revs.select {|x| x.hash.start_with?($starting_at) or x.num == $starting_at}
	rev = revs.first
	if rev == nil
		puts "couldn't find the revision you are looking for"
	else
		puts "starting from #{rev.num} (#{rev.hash[0..5]}) of #{$into.path}"
		sameAs = find_rev($from, rev)
		puts "and using #{sameAs.num} (#{sameAs.hash[0..5]}) of #{$from.path}"
	end
end