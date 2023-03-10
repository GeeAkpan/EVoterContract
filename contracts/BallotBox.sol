// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.17;

import { IPVC } from './Interfaces/IPVC.sol';
import { IBallotBox } from './Interfaces/IBallotBox.sol';


contract Ballot is IBallotBox {

    address private _owner; /// The creator of a ballot box

    string private name_;     /// The name of the ballot box

    uint256 private _totalVotes; /// The number of people that have voted on the ballot

    uint256 private _voteStart;    /// The starting period of the vote

    uint256 private _voteEnd; /// The timestamp the vote ends

    uint256 private _winner; /// The winner of a ballot box

    uint8 private tokenPerVote;

    IPVC Voter;

    uint8 private noOfVotes;
    address[] private votersAddresses;
    address private PVCTOKEN;

    // struct ConterderData {
    //     string name;
    //     uint8 voteWeight;
    // }
    /// @notice Each contender has an id
    /// @notice This maps the contender ID to their data
    mapping(bytes32 => ConterderData) public contender;
    bytes32[] contenders;
    mapping(address => bool) private hasVoted;

    constructor(
        string memory _name,
        string[] memory _contenders,
        uint256 _period,
        uint8 _tokenPerVote,
        address _PVC
    ) {
        name_ = _name;

        _voteStart = block.timestamp;
        _voteEnd = _voteStart + _period;

        tokenPerVote = _tokenPerVote;
        PVCTOKEN = _PVC;

        require(_contenders.length == 3, "The number of contenders must be 3");
        for (uint8 i = 0; i < 3; i++) {
            bytes32 thisCandidate = keccak256(bytes(_contenders[i]));
            contender[thisCandidate].name = _contenders[i];
            contenders.push(keccak256(bytes(_contenders[i])));
        }
    }

    function vote(string[] calldata _voteRank) external {
        require(block.timestamp < _voteEnd, "This ballot has ended");
        require(
            IPVC(PVCTOKEN).balanceOf(msg.sender) > tokenPerVote,
            "You don't have enough token to vote"
        );
        
        require(hasVoted[msg.sender] == false, "One Address, One Vote");

        require(_voteRank.length == 3, "You can only rank 3 contenders");

        contender[keccak256(bytes(_voteRank[0]))].voteWeight += 3;
        contender[keccak256(bytes(_voteRank[1]))].voteWeight += 2;
        contender[keccak256(bytes(_voteRank[2]))].voteWeight += 1;

        hasVoted[msg.sender] = true;
        noOfVotes += 1;
        votersAddresses.push(msg.sender);

        uint256 ownerIncentive = (tokenPerVote * 20) / 100;
        uint256 burntToken = tokenPerVote - ownerIncentive;

        IPVC(PVCTOKEN).transferFrom(msg.sender,_owner, ownerIncentive);
        IPVC(PVCTOKEN).burnTokenFor(msg.sender,burntToken);
    }

    function winner() external view returns (string memory){
        string memory winnerR = contender[contenders[0]].voteWeight >
            contender[contenders[1]].voteWeight
            ? // if true
            (
                contender[contenders[0]].voteWeight >
                    contender[contenders[2]].voteWeight
                    ? contender[contenders[0]].name
                    : contender[contenders[2]].name
            )
            : // if false
            (
                contender[contenders[1]].voteWeight >
                    contender[contenders[2]].voteWeight
                    ? contender[contenders[1]].name
                    : contender[contenders[2]].name
            );

            return winnerR;
    }

    function votersAddress() external view returns (address[] memory) {
        return votersAddresses;
    }

    function name() external view returns (string memory) {
        return name_;
    }

}