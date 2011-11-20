require 'workflow'
#
# A change is a update to production either HW or software
# @api workflow
#
class ProposedChange
  include Workflow
  workflow do
    state :proposal do
      event :submit_to_peers, :transitions_to => :under_peer_review
    end
    state :under_peer_review do
      event :peer_rejected, :transitions_to => :proposal
	  event :peer_approved, :transitions_to => :under_manager_review
    end
	state :under_manager_review do
	  event :revisions_requested, :transitions_to => :proposal
	  event :manager_approved, :transitions_to => :ready_for_deploy
	end
	state :ready_for_deploy do
	  event :deploy, :transitions_to => :deployed
	end
    state :deployed
  end
 
  def submit_to_peers
    puts 'proposal submitted for peer review'
  end
  def under_peer_review
    puts 'proposal is under peer review'
  end
  def peer_rejected
    puts 'peers find faults, please revise proposal'
  end
  def peer_approved
    puts 'peers approve change proposal'
  end
  def revisions_requested
    puts 'revisions are requested'
  end
  def manager_approved
    puts 'manager approved.  Schedule for deploy'
  end
end
