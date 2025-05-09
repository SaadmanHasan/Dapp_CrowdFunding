// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DecentralizedCrowdfunding {

    struct Campaign {
        address creator;
        string title;
        string description;
        uint256 goalAmount;
        uint256 deadline;
        uint256 fundsRaised;
        bool goalReached;
        bool isWithdrawn;
        uint256 yesbeforegoal;
        uint256 totalvotes;
        bool withdrawnbeforegoal;
        address[] contributors;
        mapping(address => uint256) contributions;
        mapping(address => bool) afterwithdraw;
    }

    uint256 public campaignCount;
    mapping(uint256 => Campaign) public campaigns;

    event CampaignCreated(
        uint256 campaignId,
        address indexed creator,
        string title,
        uint256 goalAmount,
        uint256 deadline
    );

    event ContributionMade(
        uint256 campaignId,
        address indexed contributor,
        uint256 amount
    );

    event FundsWithdrawn(uint256 campaignId, uint256 amount);
    event FundsWithdrawnBeforeGoal(uint256 campaignID, uint256 amount);

    event RefundIssued(uint256 campaignId, address indexed contributor, uint256 amount);

    // Create a new crowdfunding campaign
    function createCampaign(
        string memory _title,
        string memory _description,
        uint256 _goalAmount,
        uint256 _durationInDays
    ) external {
        require(_goalAmount > 0, "Goal amount must be greater than 0");
        require(_durationInDays > 0, "Duration must be greater than 0");

        uint256 deadline = block.timestamp + (_durationInDays * 1 days);
        campaignCount++;

        Campaign storage newCampaign = campaigns[campaignCount];
        newCampaign.creator = msg.sender;
        newCampaign.title = _title;
        newCampaign.description = _description;
        newCampaign.goalAmount = _goalAmount;
        newCampaign.deadline = deadline;

        emit CampaignCreated(campaignCount, msg.sender, _title, _goalAmount, deadline);
    }

    // Contribute to a campaign
    function contribute(uint256 _campaignId, bool canwithdrawbefore) external payable {
        Campaign storage campaign = campaigns[_campaignId];

        require(block.timestamp < campaign.deadline, "Campaign has ended");
        require(msg.value > 0, "Contribution must be greater than 0");

        campaign.fundsRaised += msg.value;
        campaign.contributions[msg.sender] += msg.value;

        if(campaign.fundsRaised > campaign.goalAmount) campaign.goalReached = true;

        if(!(campaign.withdrawnbeforegoal)){
            if(canwithdrawbefore) campaign.yesbeforegoal += msg.value;
            campaign.totalvotes += msg.value;
        }

        if(campaign.withdrawnbeforegoal) campaign.afterwithdraw[msg.sender] = true;
        if(!(campaign.withdrawnbeforegoal)) campaign.afterwithdraw[msg.sender] = false;

        campaign.contributors.push(msg.sender);

        emit ContributionMade(_campaignId, msg.sender, msg.value);
    }

    //Withdraw before campaign goal is reached if majority voters agree

    function Withdrawbeforegoal(uint256 _campaignID) external{
        Campaign storage campaign = campaigns[_campaignID];

        require(msg.sender == campaign.creator, "Only the creator can withdraw funds");
        require(block.timestamp < campaign.deadline, "Campaign Deadline has passed. Partial Withdraw not available");
        require(campaign.goalAmount > campaign.fundsRaised, "Goal has been reached. Try calling full withdrawal after deadline");
        require(!campaign.withdrawnbeforegoal, "Funds already withdrawn once");
        require(campaign.yesbeforegoal > (campaign.totalvotes/2), "Not enough votes to withdraw before goal");


        campaign.withdrawnbeforegoal = true;
        uint256 amount = campaign.fundsRaised;
        campaign.fundsRaised = 0;
        campaign.goalAmount -= amount;

        for(uint i = 0; i < campaign.contributors.length; i++){
            campaign.contributions[campaign.contributors[i]] = 0;
        }

        payable(campaign.creator).transfer(amount);

        emit FundsWithdrawnBeforeGoal(_campaignID, amount);

    }


    // Withdraw funds if the campaign goal is reached
    function withdrawFunds(uint256 _campaignId) external {
        Campaign storage campaign = campaigns[_campaignId];

        require(msg.sender == campaign.creator, "Only the creator can withdraw funds");
        require(block.timestamp >= campaign.deadline, "Campaign is still ongoing");
        require(campaign.fundsRaised >= campaign.goalAmount, "Goal not reached");
        require(!campaign.isWithdrawn, "Funds already withdrawn");

        campaign.isWithdrawn = true;
        campaign.goalReached = true;

        payable(campaign.creator).transfer(campaign.fundsRaised);

        emit FundsWithdrawn(_campaignId, campaign.fundsRaised);
    }

    // Request a refund if the campaign goal is not reached
    function requestRefund(uint256 _campaignId) external {
        Campaign storage campaign = campaigns[_campaignId];

        require(block.timestamp >= campaign.deadline, "Campaign is still ongoing");
        require(campaign.fundsRaised < campaign.goalAmount, "Goal was reached");
        require(campaign.contributions[msg.sender] > 0, "No contributions to refund");

        require(!campaign.withdrawnbeforegoal || campaign.afterwithdraw[msg.sender], 
           "Not eligible for refund");
        
        uint256 refundAmount = campaign.contributions[msg.sender];
        campaign.contributions[msg.sender] = 0;

        payable(msg.sender).transfer(refundAmount);

        emit RefundIssued(_campaignId, msg.sender, refundAmount);
    }

    // Get campaign details
    function getCampaign(uint256 _campaignId)
        external
        view
        returns (
            address creator,
            string memory title,
            string memory description,
            uint256 goalAmount,
            uint256 fundsRaised,
            uint256 deadline,
            bool goalReached,
            bool isWithdrawn, 
            bool withdrawnearly,
            uint256 yesvote,
            uint256 totalvote
        )
    {
        Campaign storage campaign = campaigns[_campaignId];
        return (
            campaign.creator,
            campaign.title,
            campaign.description,
            campaign.goalAmount,
            campaign.fundsRaised,
            campaign.deadline,
            campaign.goalReached,
            campaign.isWithdrawn,
            campaign.withdrawnbeforegoal,
            campaign.yesbeforegoal,
            campaign.totalvotes
        );
    }
}