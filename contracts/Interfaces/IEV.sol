// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.17;

import { Ballot } from '../BallotBox.sol';

interface IEV {

    event child(Ballot _child);

    function createBallot(
        string memory _name, 
        string[] memory _contenders, 
        uint256 _period, 
        uint8 _tokenPerVote
        ) external;
}