const { expect } = require("chai");

describe("Token contract", function () {
  it("deployment should assign the total supply of token to the owner",         async function() {
    const [owner] = await ethers.getSigners();
    const Token = await ethers.getContractFactory("Token");
    const hardhatToken = await Token.deploy();
    const ownerBalance = await hardhatToken.balanceOf(owner.address)
    
    expect(await hardhatToken.totalSupply()).to.equal(ownerBalance);
  })
})
