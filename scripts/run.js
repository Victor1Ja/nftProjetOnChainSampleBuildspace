const main = async () => {
  const [owner, randomPerson] = await hre.ethers.getSigners();
  const nftContractFactory = await hre.ethers.getContractFactory('MyEpicNFT');
  const nftContract = await nftContractFactory.deploy();
  await nftContract.deployed();
  console.log("Contract deployed to:", nftContract.address);

  // Call the function.
  let txn = await nftContract.makeAnEpicNFT({value: hre.ethers.utils.parseEther('0.05')})
  // Wait for it to be mined.
  await txn.wait()

  // Mint another NFT for fun.
  txn = await nftContract.makeAnEpicNFT({value: hre.ethers.utils.parseEther('0.05')})
  // Wait for it to be mined.
  await txn.wait()
  contractBalance = await hre.ethers.provider.getBalance(nftContract.address);
  console.log(hre.ethers.utils.formatEther(contractBalance));

  txn = await nftContract.withdrawEth(hre.ethers.utils.parseEther('0.04'));
  await txn.wait();
  contractBalance = await hre.ethers.provider.getBalance(nftContract.address);
  console.log(hre.ethers.utils.formatEther(contractBalance));


  txn = await nftContract.connect(randomPerson).withdrawEth(hre.ethers.utils.parseEther('0.04'));
  await txn.wait();
  contractBalance = await hre.ethers.provider.getBalance(nftContract.address);
  console.log(hre.ethers.utils.formatEther(contractBalance));

};

const runMain = async () => {
  try {
    await main();
    process.exit(0);
  } catch (error) {
    console.log(error);
    process.exit(1);
  }
};

runMain();