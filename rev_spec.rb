require 'rev'

def new_rev(id, parents)
	ret = Rev.new
	ret.hash << id
	ret.parents = parents
	ret
end

endRev = new_rev('abc3', [])

describe Rev, "#is_a_parent?" do
	describe "when it has a direct line of descendants" do
		middle = new_rev 'abc2', [endRev]
		rev = new_rev('abc1', [ middle ])
		child = new_rev 'abc4', [rev]
		wrong_branch = new_rev 'abc5', [rev.parents.first]
		
		it "should return true for parents" do
			rev.is_a_parent?(endRev).should == true
		end
		
		it "should return true if they're the same" do
			rev.is_a_parent?(rev).should == true
		end
		
		it "should return false for children" do
			rev.is_a_parent?(child).should == false
		end
		
		it "should return false if it's the wrong branch" do
			rev.is_a_parent?(wrong_branch).should == false
		end
	end
	
end