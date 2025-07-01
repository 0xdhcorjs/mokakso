// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/console.sol";

contract VoteSystem {
    uint256 public starttime;
    address[] public approvedVoters;
    mapping(address => bool) public Voted;
    bool public voteresult;
    uint8 public count = 0;
    uint8 public agree = 0;
    uint8 public disagree = 0;
    bool public isFinalized = false;

    modifier onlyApproveVoter() {
        bool found = false;
        for (uint8 i = 0; i < approvedVoters.length; i++) {
            if (msg.sender == approvedVoters[i]) {
                found = true;
                break;
            }
        }
        require(found, "You are not an approved voter");
        _;
    }

    constructor() {
        starttime = block.timestamp;
        approvedVoters = [
            0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266,
            0x70997970C51812dc3A010C7d01b50e0d17dc79C8,
            0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC,
            0x90F79bf6EB2c4f870365E785982E1f101E93b906,
            0x15d34AAf54267DB7D7c367839AAf71A00a2C6A65,
            0x9965507D1a55bcC2695C58ba16FB37d819B0A4dc,
            0x976EA74026E726554dB657fA54763abd0C3a0aa9,
            0x14dC79964da2C08b23698B3D3cc7Ca32193d9955,
            0x23618e81E3f5cdF7f54C3d65f7FBc0aBf5B21E8f,
            0xa0Ee7A142d267C1f36714E4a8F75612F20a79720
        ];
    }

    function vote(bool voters) public onlyApproveVoter returns (bool) {
        require(block.timestamp < starttime + 5 minutes, "Voting period has ended");
        require(!Voted[msg.sender], "Already voted");
        Voted[msg.sender] = voters;
        count++;
        return true;
    }

    function finalVoteResult() public returns (bool) {
        require(block.timestamp >= starttime + 5 minutes, "Voting period is still ongoing");
        require(!isFinalized, "Vote has already been finalized");

        for (uint8 i = 0; i < approvedVoters.length; i++) {
            if (Voted[approvedVoters[i]] == true) {
                agree++;
            } else {
                disagree++;
            }
        }

        voteresult = (agree > disagree);
        isFinalized = true;
        return voteresult;
    }

    function viewVoteResult() public view returns (string memory) {
        if (block.timestamp < starttime + 5 minutes) {
            return "Voting is still pending";
        } else if (!isFinalized) {
            return "Voting ended. Awaiting finalization.";
        } else {
            return voteresult ? "Voting accepted" : "Voting rejected";
        }
    }
}
