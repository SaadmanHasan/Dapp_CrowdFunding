
This repository contains the source code for a decentralized crowdfunding platform built on the Ethereum blockchain using Solidity. This smart contract allows users to create fundraising campaigns, contribute to them, and manage funds in a transparent and secure manner.

## Features

- **Create Campaigns**: Users can launch their own crowdfunding campaigns with a specific title, description, funding goal, and deadline.
- **Contribute Funds**: Anyone can contribute Ether to a campaign. All contributions are tracked on the blockchain.
- **Withdrawal After Success**: Campaign creators can withdraw the raised funds only if the funding goal has been met by the deadline.
- **Democratic Early Withdrawal**: Creators can withdraw funds _before_ the goal is met if a majority of the contribution value votes in favor of it.
- **Automatic Refunds**: If a campaign fails to meet its funding goal by the deadline, contributors can request a full refund of their contributed amount.
## Smart Contract Functions

`createCampaign`
Creates a new crowdfunding campaign.
- `_title`: The title of the campaign.
- `_description`: A detailed description of the campaign.
- `_goalAmount`: The amount of Ether the campaign aims to raise.
- `_durationInDays`: The number of days the campaign will be active.

`contribute`
Allows a user to contribute Ether to a specific campaign.
- `_campaignId`: The ID of the campaign to contribute to.
- `canwithdrawbefore`: A boolean vote (`true`/`false`) on whether the creator should be allowed to withdraw funds before the goal is met.

`Withdrawbeforegoal`
Allows the campaign creator to withdraw funds before the funding goal is met, provided that the majority of contribution value has voted in favor of it.
- `_campaignID`: The ID of the campaign from which to withdraw.

`withdrawFunds`
Allows the campaign creator to withdraw the total funds raised after the campaign has successfully met its goal and the deadline has passed.
- `_campaignId`: The ID of the campaign.

`requestRefund`
Allows a contributor to get a refund if the campaign goal was not met by the deadline.
- `_campaignId`: The ID of the campaign.

`getCampaign`
A public view function to retrieve the details of a specific campaign.
- `_campaignId`: The ID of the campaign.

## Getting Started

To deploy this contract or interact with it, you can use an Ethereum development environment like Remix, Hardhat, or Truffle.

1. **Compile the Contract**: Copy the code into your preferred environment and compile it with a Solidity compiler version of `^0.8.0`.
2. **Deploy**: Deploy the compiled `DecentralizedCrowdfunding` contract to an Ethereum network (e.g., a local testnet, a public testnet like Sepolia, or the mainnet).
3. **Interact**: Once deployed, you can call the functions using a wallet like MetaMask or through a custom dApp interface.

## License

This project is licensed under the MIT License. See the `// SPDX-License-Identifier: MIT` line at the top of the contract file for more details.

## Ethereum TestNet

- Sepolia (11155111) network

## UI Link 

- [https://saadmanhasan.github.io/Dapp_CrowdFunding/](https://saadmanhasan.github.io/Dapp_CrowdFunding/)

Contract Link

- [https://sepolia.etherscan.io/address/0xD70cacE5e114EaaeF24227A507D3B2Faba6cAaaB#code](https://sepolia.etherscan.io/address/0xD70cacE5e114EaaeF24227A507D3B2Faba6cAaaB#code)