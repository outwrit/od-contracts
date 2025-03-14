// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.19;

// --- Base Contracts ---
import {SystemCoin, ISystemCoin} from '@contracts/tokens/SystemCoin.sol';
import {ProtocolToken, IProtocolToken} from '@contracts/tokens/ProtocolToken.sol';
import {SAFEEngine, ISAFEEngine} from '@contracts/SAFEEngine.sol';
import {TaxCollector, ITaxCollector} from '@contracts/TaxCollector.sol';
import {AccountingEngine, IAccountingEngine} from '@contracts/AccountingEngine.sol';
import {LiquidationEngine, ILiquidationEngine} from '@contracts/LiquidationEngine.sol';
import {SurplusAuctionHouse, ISurplusAuctionHouse} from '@contracts/SurplusAuctionHouse.sol';
import {DebtAuctionHouse, IDebtAuctionHouse} from '@contracts/DebtAuctionHouse.sol';
import {CollateralAuctionHouse, ICollateralAuctionHouse} from '@contracts/CollateralAuctionHouse.sol';
import {StabilityFeeTreasury, IStabilityFeeTreasury} from '@contracts/StabilityFeeTreasury.sol';
import {PIDController, IPIDController} from '@contracts/PIDController.sol';
import {PIDRateSetter, IPIDRateSetter} from '@contracts/PIDRateSetter.sol';

// --- Settlement ---
import {GlobalSettlement, IGlobalSettlement} from '@contracts/settlement/GlobalSettlement.sol';
import {
  PostSettlementSurplusAuctionHouse,
  IPostSettlementSurplusAuctionHouse
} from '@contracts/settlement/PostSettlementSurplusAuctionHouse.sol';
import {
  SettlementSurplusAuctioneer,
  ISettlementSurplusAuctioneer
} from '@contracts/settlement/SettlementSurplusAuctioneer.sol';

// --- Oracles ---
import {OracleRelayer, IOracleRelayer} from '@contracts/OracleRelayer.sol';
import {IBaseOracle} from '@interfaces/oracles/IBaseOracle.sol';
import {DelayedOracle, IDelayedOracle} from '@contracts/oracles/DelayedOracle.sol';
import {DenominatedOracle} from '@contracts/oracles/DenominatedOracle.sol';
import {ChainlinkRelayer} from '@contracts/oracles/ChainlinkRelayer.sol';
import {UniV3Relayer} from '@contracts/oracles/UniV3Relayer.sol';
import {CamelotRelayer} from '@contracts/oracles/CamelotRelayer.sol';

// --- Testnet contracts ---
import {MintableERC20} from '@contracts/for-test/MintableERC20.sol';
import {MintableVoteERC20} from '@contracts/for-test/MintableVoteERC20.sol';
import {DeviatedOracle} from '@contracts/for-test/DeviatedOracle.sol';
import {HardcodedOracle} from '@contracts/for-test/HardcodedOracle.sol';

// --- Token adapters ---
import {CoinJoin, ICoinJoin} from '@contracts/utils/CoinJoin.sol';
import {ETHJoin, IETHJoin} from '@contracts/utils/ETHJoin.sol';
import {CollateralJoin, ICollateralJoin} from '@contracts/utils/CollateralJoin.sol';

// --- Factories ---
import {CollateralJoinFactory, ICollateralJoinFactory} from '@contracts/factories/CollateralJoinFactory.sol';
import {
  CollateralAuctionHouseFactory,
  ICollateralAuctionHouseFactory
} from '@contracts/factories/CollateralAuctionHouseFactory.sol';
import {ChainlinkRelayerFactory, IChainlinkRelayerFactory} from '@contracts/factories/ChainlinkRelayerFactory.sol';
import {UniV3RelayerFactory, IUniV3RelayerFactory} from '@contracts/factories/UniV3RelayerFactory.sol';
import {CamelotRelayerFactory, ICamelotRelayerFactory} from '@contracts/factories/CamelotRelayerFactory.sol';
import {IAlgebraFactory as ICamelotV3Factory} from '@interfaces/factories/IAlgebraFactory.sol';
import {DenominatedOracleFactory, IDenominatedOracleFactory} from '@contracts/factories/DenominatedOracleFactory.sol';
import {DelayedOracleFactory, IDelayedOracleFactory} from '@contracts/factories/DelayedOracleFactory.sol';

// --- Jobs ---
import {AccountingJob, IAccountingJob} from '@contracts/jobs/AccountingJob.sol';
import {LiquidationJob, ILiquidationJob} from '@contracts/jobs/LiquidationJob.sol';
import {OracleJob, IOracleJob} from '@contracts/jobs/OracleJob.sol';

// --- Interfaces ---
import {IERC20Metadata} from '@openzeppelin/token/ERC20/extensions/IERC20Metadata.sol';
import {IModifiable} from '@interfaces/utils/IModifiable.sol';
import {IAuthorizable} from '@interfaces/utils/IAuthorizable.sol';

// --- Proxy Contracts ---
import {BasicActions, CommonActions} from '@contracts/proxies/actions/BasicActions.sol';
import {DebtBidActions} from '@contracts/proxies/actions/DebtBidActions.sol';
import {SurplusBidActions} from '@contracts/proxies/actions/SurplusBidActions.sol';
import {CollateralBidActions} from '@contracts/proxies/actions/CollateralBidActions.sol';
import {PostSettlementSurplusBidActions} from '@contracts/proxies/actions/PostSettlementSurplusBidActions.sol';
import {GlobalSettlementActions} from '@contracts/proxies/actions/GlobalSettlementActions.sol';
import {RewardedActions} from '@contracts/proxies/actions/RewardedActions.sol';
import {GlobalSettlementActions} from '@contracts/proxies/actions/GlobalSettlementActions.sol';
import {PostSettlementSurplusBidActions} from '@contracts/proxies/actions/PostSettlementSurplusBidActions.sol';
import {ODProxy} from '@contracts/proxies/ODProxy.sol';
import {ODSafeManager} from '@contracts/proxies/ODSafeManager.sol';
import {Vault721} from '@contracts/proxies/Vault721.sol';
import {NFTRenderer} from '@contracts/proxies/NFTRenderer.sol';

// --- Governance Contracts ---
import {TimelockController} from '@openzeppelin/governance/TimelockController.sol';
import {ODGovernor} from '@contracts/gov/ODGovernor.sol';

// --- ForTestnet ---
import {OracleForTest} from '@contracts/for-test/OracleForTest.sol';
import {OracleForTestnet} from '@contracts/for-test/OracleForTestnet.sol';

/**
 * @title  Contracts
 * @notice This contract initializes all the contracts, so that they're inherited and available throughout scripts scopes.
 * @dev    It exports all the contracts and interfaces to be inherited or modified during the scripts dev and execution.
 */
abstract contract Contracts {
  // --- Helpers ---
  uint256 public chainId;
  address public deployer;
  address public governor;
  address public delegate;
  bytes32[] public collateralTypes;
  mapping(bytes32 => address) public delegatee;

  // --- Base contracts ---
  ISAFEEngine public safeEngine;
  ITaxCollector public taxCollector;
  IAccountingEngine public accountingEngine;
  ILiquidationEngine public liquidationEngine;
  IOracleRelayer public oracleRelayer;
  ISurplusAuctionHouse public surplusAuctionHouse;
  IDebtAuctionHouse public debtAuctionHouse;
  IStabilityFeeTreasury public stabilityFeeTreasury;
  mapping(bytes32 => ICollateralAuctionHouse) public collateralAuctionHouse;

  // --- Token contracts ---
  IProtocolToken public protocolToken;
  ISystemCoin public systemCoin;
  mapping(bytes32 => MintableERC20) public erc20;
  mapping(bytes32 => IERC20Metadata) public collateral;
  ICoinJoin public coinJoin;
  IETHJoin public ethJoin;
  mapping(bytes32 => ICollateralJoin) public collateralJoin;

  // --- Oracle contracts ---
  IBaseOracle public systemCoinOracle;
  mapping(bytes32 => IDelayedOracle) public delayedOracle;

  // --- PID contracts ---
  IPIDController public pidController;
  IPIDRateSetter public pidRateSetter;

  // --- Factory contracts ---
  ICollateralJoinFactory public collateralJoinFactory;
  ICollateralAuctionHouseFactory public collateralAuctionHouseFactory;

  IChainlinkRelayerFactory public chainlinkRelayerFactory;
  IUniV3RelayerFactory public uniV3RelayerFactory;
  ICamelotRelayerFactory public camelotRelayerFactory;
  IDenominatedOracleFactory public denominatedOracleFactory;
  IDelayedOracleFactory public delayedOracleFactory;

  ICamelotV3Factory public camelotV3Factory;

  // --- Settlement contracts ---
  IGlobalSettlement public globalSettlement;
  IPostSettlementSurplusAuctionHouse public postSettlementSurplusAuctionHouse;
  ISettlementSurplusAuctioneer public settlementSurplusAuctioneer;

  // --- Job contracts ---
  IAccountingJob public accountingJob;
  ILiquidationJob public liquidationJob;
  IOracleJob public oracleJob;

  // --- Proxy contracts ---
  ODSafeManager public safeManager;
  Vault721 public vault721;
  NFTRenderer public nftRenderer;

  BasicActions public basicActions;
  DebtBidActions public debtBidActions;
  SurplusBidActions public surplusBidActions;
  CollateralBidActions public collateralBidActions;
  RewardedActions public rewardedActions;
  GlobalSettlementActions public globalSettlementActions;
  PostSettlementSurplusBidActions public postSettlementSurplusBidActions;

  // --- Governance Contracts ---
  TimelockController public timelockController;
  ODGovernor public odGovernor;
}
