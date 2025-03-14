// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.19;

import {Script} from 'forge-std/Script.sol';
import {GoerliContracts} from '@script/GoerliContracts.s.sol';
import {ODGovernor} from '@contracts/gov/ODGovernor.sol';
import {TimelockController} from '@openzeppelin/governance/TimelockController.sol';
import {H, J, P} from '@script/Registry.s.sol';

// BROADCAST
// source .env && forge script DeployGovernor --with-gas-price 2000000000 -vvvvv --rpc-url $GOERLI_RPC --broadcast --verify --etherscan-api-key $ETHERSCAN_API_KEY

// SIMULATE
// source .env && forge script DeployGovernor --with-gas-price 2000000000 -vvvvv --rpc-url $GOERLI_RPC

contract DeployGovernor is GoerliContracts, Script {
  function run() public {
    vm.startBroadcast(vm.envUint('GOERLI_PK'));
    address[] memory members = new address[](3);
    members[0] = H;
    members[1] = J;
    members[2] = P;

    TimelockController timelockController = new TimelockController(1 minutes, members, members, address(0));
    ODGovernor odGovernor = new ODGovernor(ProtocolToken_Address, timelockController);
    vm.stopBroadcast();
  }
}
