// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.19;

import {OracleForTest} from '@test/mocks/OracleForTest.sol';
import {Authorizable} from '@contracts/utils/Authorizable.sol';
import {IBaseOracle} from '@interfaces/oracles/IBaseOracle.sol';
import {J, P} from '@script/Registry.s.sol';

// solhint-disable
contract OracleForTestnet is IBaseOracle, Authorizable, OracleForTest {
  constructor(uint256 _price) OracleForTest(_price) Authorizable(msg.sender) {
    _addAuthorization(J);
    _addAuthorization(P);
  }

  function setPriceAndValidity(uint256 _price, bool _validity) public override isAuthorized {
    super.setPriceAndValidity(_price, _validity);
  }

  function setThrowsError(bool _throwError) public override isAuthorized {
    super.setThrowsError(_throwError);
  }
}
