// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.19;

import {IVotes} from '@openzeppelin/governance/utils/IVotes.sol';
import {IERC165} from '@openzeppelin/utils/introspection/IERC165.sol';
import {IGovernor} from '@openzeppelin/governance/IGovernor.sol';

import {TimelockController} from '@openzeppelin/governance/TimelockController.sol';

import {Governor} from '@openzeppelin/governance/Governor.sol';
import {GovernorSettings} from '@openzeppelin/governance/extensions/GovernorSettings.sol';
import {GovernorCompatibilityBravo} from '@openzeppelin/governance/compatibility/GovernorCompatibilityBravo.sol';
import {GovernorVotes} from '@openzeppelin/governance/extensions/GovernorVotes.sol';
import {GovernorVotesQuorumFraction} from '@openzeppelin/governance/extensions/GovernorVotesQuorumFraction.sol';
import {GovernorTimelockControl} from '@openzeppelin/governance/extensions/GovernorTimelockControl.sol';

contract ODGovernor is
  Governor,
  GovernorSettings,
  GovernorCompatibilityBravo,
  GovernorVotes,
  GovernorVotesQuorumFraction,
  GovernorTimelockControl
{
  /**
   *
   * @param _token is protocolToken (Open Dollar Governance, ODG)
   * @param _timelock grace period to allow rage quit between proposal success and execution
   *
   * Governor(name)
   * GovernorSettings(initialVotingDelay, initialVotingPeriod, initialProposalThreshold) measured in blocks
   * GovernorVotes(protocolToken)
   * GovernorVotesQuorumFraction(percentage-to-pass-quorum)
   * GovernorTimelockControl(timelock-contract)
   */
  constructor(
    address _token,
    TimelockController _timelock
  )
    Governor('ODGovernor')
    GovernorSettings(1, 15, 0)
    GovernorVotes(IVotes(_token))
    GovernorVotesQuorumFraction(3)
    GovernorTimelockControl(_timelock)
  {}

  /**
   * @dev - below are required override functions -
   *
   * inherit: GovernorSettings
   */
  function votingDelay() public view override(IGovernor, GovernorSettings) returns (uint256) {
    return super.votingDelay();
  }

  /**
   * inherit: GovernorSettings
   */
  function votingPeriod() public view override(IGovernor, GovernorSettings) returns (uint256) {
    return super.votingPeriod();
  }

  /**
   * inherit: GovernorVotesQuorumFraction
   */
  function quorum(uint256 blockNumber) public view override(IGovernor, GovernorVotesQuorumFraction) returns (uint256) {
    return super.quorum(blockNumber);
  }

  /**
   * inherit: Governor, GovernorTimelockControl
   */
  function state(uint256 proposalId)
    public
    view
    override(Governor, IGovernor, GovernorTimelockControl)
    returns (ProposalState)
  {
    return super.state(proposalId);
  }

  /**
   * inherit: Governor, GovernorCompatibilityBravo
   */
  function propose(
    address[] memory targets,
    uint256[] memory values,
    bytes[] memory calldatas,
    string memory description
  ) public override(Governor, GovernorCompatibilityBravo, IGovernor) returns (uint256) {
    return super.propose(targets, values, calldatas, description);
  }

  /**
   * inherit: Governor, GovernorSettings
   */
  function proposalThreshold() public view override(Governor, GovernorSettings) returns (uint256) {
    return super.proposalThreshold();
  }

  /**
   * inherit: Governor, GovernorTimelockControl
   */
  function _execute(
    uint256 proposalId,
    address[] memory targets,
    uint256[] memory values,
    bytes[] memory calldatas,
    bytes32 descriptionHash
  ) internal override(Governor, GovernorTimelockControl) {
    super._execute(proposalId, targets, values, calldatas, descriptionHash);
  }

  /**
   * inherit: Governor, GovernorTimelockControl
   */
  function _cancel(
    address[] memory targets,
    uint256[] memory values,
    bytes[] memory calldatas,
    bytes32 descriptionHash
  ) internal override(Governor, GovernorTimelockControl) returns (uint256) {
    return super._cancel(targets, values, calldatas, descriptionHash);
  }

  /**
   * inherit: Governor, GovernorTimelockControl
   */
  function _executor() internal view override(Governor, GovernorTimelockControl) returns (address) {
    return super._executor();
  }

  /**
   * inherit: Governor, GovernorTimelockControl
   */
  function supportsInterface(bytes4 interfaceId)
    public
    view
    override(Governor, IERC165, GovernorTimelockControl)
    returns (bool)
  {
    return super.supportsInterface(interfaceId);
  }
}
