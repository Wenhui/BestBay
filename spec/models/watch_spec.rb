require 'spec_helper'


describe Watch do
  it { should belong_to :watcher }
  it { should belong_to :watched_item } 

before {@watch = Watch.new} 
  describe "invalid watch" do
  		
	  it { should_not be_valid }

	end
	# describe "valid watch" do
	# 	@watch.item_id = 1
	# 	it {should be_valid}
	# end 


end
