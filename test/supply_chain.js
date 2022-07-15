const supplyChain = artifacts.require('./supplyChain.sol');

/*
 * uncomment accounts to access the test accounts made available by the
 * Ethereum client
 * See docs: https://www.trufflesuite.com/docs/truffle/testing/writing-tests-in-javascript
 */
contract('supplyChain', async accounts => {
  it("should create a Participant", async () => {
    let instance = await supplyChain.deployed();
    let participantId = await instance.addParticipant("A","passA","0x7De982f8311BF76c81fdD27F4A762F6d40c0fdb9","Manufacturer");
    let participant = await instance.participants(0);
    assert.equal(participant[0], "A");
    assert.equal(participant[3], "Manufacturer");
    });
});
