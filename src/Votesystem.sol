// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/console.sol";

contract VoteSystem {
    struct Proposal {
        uint256 id;
        address to;
        uint256 value;
        bytes data;
        uint256 agree;
        uint256 disagree;
        bool finalized;
        bool result;
        mapping(address => bool) voted;
    }

    mapping(uint256 => Proposal) public proposals;
    address[] public approvedVoters;
    mapping(address => bool) public isApprovedVoter;
    uint256 public starttime;

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

        for (uint8 i = 0; i < approvedVoters.length; i++) {
            isApprovedVoter[approvedVoters[i]] = true;
        }
    }

    function createProposal(
        uint256 id,
        address to,
        uint256 value,
        bytes calldata data
    ) external {
        require(proposals[id].to == address(0), "Proposal already exists");
        Proposal storage p = proposals[id];
        p.id = id;
        p.to = to;
        p.value = value;
        p.data = data;
    }

    function voteWithSig(
        uint256 id,
        address to,
        uint256 value,
        bytes calldata data,
        bool support,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external {
        bytes32 hash = keccak256(abi.encodePacked(id, to, value, data));
        address signer = ecrecover(hash, v, r, s);

        require(signer != address(0), "Invalid signature");
        require(isApprovedVoter[signer], "Not approved voter");
        require(!proposals[id].voted[signer], "Already voted");

        proposals[id].voted[signer] = true;

        if (support) {
            proposals[id].agree++;
        } else {
            proposals[id].disagree++;
        }
    }

    function finalize(uint256 id) external {
        Proposal storage p = proposals[id];
        require(!p.finalized, "Already finalized");
        require(block.timestamp >= starttime + 5 minutes, "Voting ongoing");

        p.result = p.agree > p.disagree;
        p.finalized = true;
    }

    function viewVoteResult(uint256 id) external view returns (string memory) {
        Proposal storage p = proposals[id];

        if (!p.finalized) {
            if (block.timestamp < starttime + 5 minutes) {
                return "Voting is still pending";
            } else {
                return "Voting ended. Awaiting finalization.";
            }
        } else {
            return p.result ? "Voting accepted" : "Voting rejected";
        }
    }
}
