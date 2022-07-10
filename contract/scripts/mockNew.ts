import {ethers} from "hardhat";

async function main() {
    const Token = await ethers.getContractFactory("Token");
    const nw = await Token.deploy("New", "NEW"); // トークンの名前
    await nw.deployed();
    console.log("new deployed to:", nw.address);
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
