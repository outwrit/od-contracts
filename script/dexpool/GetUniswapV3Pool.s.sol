// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.19;

import {LiquidityBase} from '@script/dexpool/base/LiquidityBase.s.sol';

// BROADCAST
// source .env && forge script GetUniswapV3Pool --with-gas-price 2000000000 -vvvvv --rpc-url $GOERLI_RPC --broadcast --verify --etherscan-api-key $ETHERSCAN_API_KEY

// SIMULATE
// source .env && forge script GetUniswapV3Pool --with-gas-price 2000000000 -vvvvv --rpc-url $GOERLI_RPC

contract GetUniswapV3Pool is LiquidityBase {
  address public pool;

  function run() public {
    vm.startBroadcast(vm.envUint('GOERLI_PK'));
    pool = uniswapV3Factory.getPool(tokenA, tokenB, fee);
    vm.stopBroadcast();
  }
}
