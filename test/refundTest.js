'use strict';
var TokenOffering = artifacts.require('./helpers/PolyMathTokenOfferingMock.sol');
var POLYToken = artifacts.require('PolyMathToken.sol');

import { latestTime, duration } from './helpers/latestTime';

contract('TokenOffering', async function ([miner, owner, investor, wallet]) {
  let tokenOfferingDeployed;
  let tokenDeployed;
  beforeEach(async function () {
    tokenDeployed = await POLYToken.new();
    const startTime = latestTime() + duration.seconds(1);
    const endTime = startTime + duration.weeks(1);
    const rate = new web3.BigNumber(1000);
    const cap = new web3.BigNumber(1 * Math.pow(10, 18));
    console.log(startTime, endTime);
    tokenOfferingDeployed = await TokenOffering.new(tokenDeployed.address, startTime, endTime, rate, cap, wallet);
    await tokenOfferingDeployed.setBlockTimestamp(startTime + duration.days(1));
  });

    it('refund excess ETH if contribution is above cap', async function () {
      let cap = await tokenOfferingDeployed.cap();
      console.log (cap)
      await tokenOfferingDeployed.whitelistAddresses([investor], true);
      await tokenOfferingDeployed.sendTransaction({ from: investor, value: cap+1, gas: '200000' })
      balance = await tokenOfferingDeployed.allocations(investor);
      assert.equal(balance.toNumber(), cap*(1000).toNumber());
    });
});
