require "rubygems"
require "bundler/setup"
require 'simplecov'
SimpleCov.start
#require File.expand_path(File.dirname(__FILE__) + '/../lib/technology.rb')
require_relative "../lib/proposed_change.rb"

describe "states" do

  subject { ProposedChange.new } 

  it "should start as a proposal" do
    subject.current_state.to_s.should == "proposal"
  end

  context "when under peer review" do
    it "should be under peer review" do
	  subject.submit_to_peers!
	  subject.under_peer_review?.should == true
	  subject.current_state.to_s.should == "under_peer_review"
	end
    it "should not be deployable when under peer review" do
	  expect { subject.deploy! }.to raise_error
	end
	it "should tell us its submitted for peer review" do
	  expect { subject.submit_to_peers!}.to_s == "proposal submitted for peer review"
	end
	it "can be rejected by peers" do
	  subject.submit_to_peers!
	  subject.peer_rejected!
	  subject.current_state.to_s.should == "proposal"
	end
	it "available events should be peer_rejected and peer_approved" do
	  subject.submit_to_peers!
	  subject.current_state.events.should have_key(:peer_rejected)
	  subject.current_state.events.should have_key(:peer_approved)
	  subject.current_state.events.keys.should == [:peer_rejected,:peer_approved] 
	end
  end
  context "when under manager review" do
    it "should be under manager review" do
	  subject.submit_to_peers!
	  subject.peer_approved!
	  subject.under_manager_review?.should == true
	  subject.current_state.to_s.should == "under_manager_review"
	end
	it "should not be deployable under manager review" do
	  subject.submit_to_peers!
	  subject.peer_approved!
	  expect { subject.deploy! }.to raise_error
	end
	it "should tell us its under manager review" do
	  subject.submit_to_peers!
	  expect { subject.peer_approved!}.to_s == "peers approve change proposal, submitted for manager approval"
	end
	it "can be send back for revisions" do
	  subject.submit_to_peers!
	  subject.peer_approved!
	  subject.revisions_requested!
	  subject.current_state.to_s.should == "proposal"
	end
	it "available events should be revisions_requested and manager_approved" do
	  subject.submit_to_peers!
	  subject.peer_approved!
	  subject.current_state.events.should have_key(:revisions_requested)
	  subject.current_state.events.should have_key(:manager_approved)
	  subject.current_state.events.keys.should == [:revisions_requested,:manager_approved]
	end
	
	context "when deployed" do
	  it "should be deployed" do
	    subject.submit_to_peers!
	    subject.peer_approved!
		subject.manager_approved!
		subject.deploy!
		subject.current_state.to_s.should == "deployed"
	  end
	end
  
  end
end
