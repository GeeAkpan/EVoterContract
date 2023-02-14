// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.17;
/// Ballotbox for the users to vote their preferred candidate
interface IBallotBox {
    struct ConterderData {
        string name;
        uint8 voteWeight;
    }
    function vote(string[] calldata _voteRank) external;
    function winner() external view returns (string memory);
    function votersAddress() external view returns (address[] memory);
    function name() external view returns (string memory);
}