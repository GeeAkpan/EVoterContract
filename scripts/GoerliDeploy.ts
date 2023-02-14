import { ethers } from "hardhat";
import { anyValue } from '@nomicfoundation/hardhat-chai-matchers/withArgs';

const VotingToken = {
    name : "INEC Voting Token",
    symbol : "PVC",
    decimal : 2,
    totalSupply_ : 6_000_000
}

async function main() {

    // Get Accounts 
    const [owner, acct1, acct2, acct3] = await ethers.getSigners();
    
    // Deploy the INEC Contract
    const INEC = await ethers.getContractFactory("INEC");
    const INEC_ = await INEC.deploy();
    await INEC_.deployed();
    console.log(`The INEC Contract has been deployed to ${INEC_.address}`);


}

main().catch((e)=> {
    console.log(e);
    process.exitCode = 1;
})