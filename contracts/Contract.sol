pragma solidity >= 0.7.0 < 0.9.0;

contract Ballot {
  struct Voter {
    uint weight;
    bool voted;
    address delegate;
    uint vote;    
  }

  struct Proposal {
    bytes32 name;
    uint voteCount;
  }

  address public chairperson;

  mapping(address => Voter) public voters;

  Proposal[] public proposals;

  constructor(bytes32[] memory proposalNames) {
    chairperson = msg.sender;
    voters[chairperson].weight = 1;

    for(uint i = 0; i < proposalNames.length; i++) {
      Proposal memory prop = Proposal(proposalNames[i], 0);
      proposals.push(prop);
    }
  }

  function giveRightToVoter(address voter) external {
    require(
      msg.sender == chairperson,
      "only chairperson can give right to vote."
    );

    require(
      !voters[voter].voted,
      "The voter already voted."
    );

    require(voters[voter].weight == 0);
    voters[voter].weight = 1;
  }

  function delegate(address to) external {
    Voter storage sender = voters[msg.sender];
    require(sender.weight != 0, "You have no right to vote");
    require(!sender.voted, "You already voted.");

    require(to != msg.sender, "Self delegation is disallowed.");

    while(voters[to].delegate != address(0)) {
      to = voters[to].delegate;

      require(to != msg.sender, "Found loop in delegation.");

      Voter storage delegate_ = voters[to];
      require(delegate_.weight >= 1);

      sender.voted = true;
      sender.delegate = to;

      if(delegate_.voted) {
        proposals[delegate_.vote].voteCount += sender.weight;
      } else {
        delegate_.weight += sender.weight;
      }
    }
  }
}
