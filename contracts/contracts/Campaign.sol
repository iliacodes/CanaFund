//SPDX License Identifier: MIT
pragma solidity ^0.8.0;

contract CanaFund {


  struct Campaign {
    address owner;
    string name;
    string description;
    uint256 goal;
    uint256 deadline;
    uint256 raised;
    address[] donars;
    uint256[] donations;
  }

  mapping(uint256 => Campaign) public campaigns;

  uint256 public numberOfCampaigns = 0;

  function create(address _owner, string memory _title, string memory _description, uint256 _goal, uint256 _deadline, uint256 _raised) public returns (uint256){
    Campaign storage campaign = campaigns[numberOfCampaigns];
    require(campaign.deadline < block.timestamp, "Deadline set has passed");

    campaign.owner = _owner;
    campaign.name = _title;
    campaign.description = _description;
    campaign.goal = _goal;
    campaign.deadline = _deadline;
    campaign.raised = _raised;
    numberOfCampaigns++;

    return numberOfCampaigns - 1;
  }

  function donate(uint256 _id) public payable {
    uint256 amount = msg.value;
    Campaign storage campaign = campaigns[_id];

    campaign.donars.push(msg.sender);
    campaign.donations.push(amount);

    (bool success,) = payable(campaign.owner).call{value: amount}("");

    if (success) {
      campaign.raised = campaign.raised + amount;
    }
  }

  function getDonars(uint256 _id) public view returns (address[] memory, uint256[] memory){
    return (campaigns[_id].donars, campaigns[_id].donations);
  }

  function getCampaigns() public view returns (Campaign[] memory) {
    Campaign[] memory allCampaigns = new Campaign[](numberOfCampaigns);

    for (uint256 i = 0; i < numberOfCampaigns; i++) {
      Campaign storage item = campaigns[i];
      allCampaigns[i] = item;
    }
    return allCampaigns;
  }

}