// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.19;

import '@script/Contracts.s.sol';
import {GoerliParams, WSTETH, ARB, CBETH, RETH, MAGIC} from '@script/GoerliParams.s.sol';
import {GOERLI_CAMELOT_V3_FACTORY} from '@script/Registry.s.sol';
import {GoerliContracts} from '@script/GoerliContracts.s.sol';

abstract contract GoerliDeployment is Contracts, GoerliParams, GoerliContracts {
  // NOTE: The last significant change in the Goerli deployment, to be used in the test scenarios
  uint256 constant GOERLI_DEPLOYMENT_BLOCK = 12_872_701;

  /**
   * @notice All the addresses that were deployed in the Goerli deployment, in order of creation
   * @dev    This is used to import the deployed contracts to the test scripts
   */
  constructor() {
    // --- collateral types ---
    collateralTypes.push(ARB);
    collateralTypes.push(WSTETH);
    collateralTypes.push(CBETH);
    collateralTypes.push(RETH);
    collateralTypes.push(MAGIC);

    // --- utils ---
    delegatee[ARB] = governor;

    // --- ERC20s ---
    collateral[ARB] = IERC20Metadata(MintableVoteERC20_Address);
    collateral[WSTETH] = IERC20Metadata(MintableERC20_WSTETH_Address);
    collateral[CBETH] = IERC20Metadata(MintableERC20_CBETH_Address);
    collateral[RETH] = IERC20Metadata(MintableERC20_RETH_Address);
    collateral[MAGIC] = IERC20Metadata(MintableERC20_MAGIC_Address);

    systemCoin = SystemCoin(SystemCoin_Address);
    protocolToken = ProtocolToken(ProtocolToken_Address);

    // --- base contracts ---
    safeEngine = SAFEEngine(SAFEEngine_Address);
    oracleRelayer = OracleRelayer(OracleRelayer_Address);
    surplusAuctionHouse = SurplusAuctionHouse(SurplusAuctionHouse_Address);
    debtAuctionHouse = DebtAuctionHouse(DebtAuctionHouse_Address);
    accountingEngine = AccountingEngine(AccountingEngine_Address);
    liquidationEngine = LiquidationEngine(LiquidationEngine_Address);
    coinJoin = CoinJoin(CoinJoin_Address);
    taxCollector = TaxCollector(TaxCollector_Address);
    stabilityFeeTreasury = StabilityFeeTreasury(StabilityFeeTreasury_Address);
    pidController = PIDController(PIDController_Address);
    pidRateSetter = PIDRateSetter(PIDRateSetter_Address);

    // --- global settlement ---
    globalSettlement = GlobalSettlement(GlobalSettlement_Address);
    postSettlementSurplusAuctionHouse = PostSettlementSurplusAuctionHouse(PostSettlementSurplusAuctionHouse_Address);
    settlementSurplusAuctioneer = SettlementSurplusAuctioneer(SettlementSurplusAuctioneer_Address);

    // --- factories ---
    chainlinkRelayerFactory = ChainlinkRelayerFactory(ChainlinkRelayerFactory_Address);
    uniV3RelayerFactory = UniV3RelayerFactory(UniV3RelayerFactory_Address);
    camelotRelayerFactory = CamelotRelayerFactory(CamelotRelayerFactory_Address);
    denominatedOracleFactory = DenominatedOracleFactory(DenominatedOracleFactory_Address);
    delayedOracleFactory = DelayedOracleFactory(DelayedOracleFactory_Address);

    collateralJoinFactory = CollateralJoinFactory(CollateralJoinFactory_Address);
    collateralAuctionHouseFactory = CollateralAuctionHouseFactory(CollateralAuctionHouseFactory_Address);

    // --- per token contracts ---
    collateralJoin[ARB] =
      CollateralJoin(CollateralJoinChild_0x4152420000000000000000000000000000000000000000000000000000000000_Address);
    collateralAuctionHouse[ARB] = CollateralAuctionHouse(
      CollateralAuctionHouseChild_0x4152420000000000000000000000000000000000000000000000000000000000_Address
    );

    collateralJoin[WSTETH] =
      CollateralJoin(CollateralJoinChild_0x5753544554480000000000000000000000000000000000000000000000000000_Address);
    collateralAuctionHouse[WSTETH] = CollateralAuctionHouse(
      CollateralAuctionHouseChild_0x5753544554480000000000000000000000000000000000000000000000000000_Address
    );

    collateralJoin[CBETH] =
      CollateralJoin(CollateralJoinChild_0x4342455448000000000000000000000000000000000000000000000000000000_Address);
    collateralAuctionHouse[CBETH] = CollateralAuctionHouse(
      CollateralAuctionHouseChild_0x4342455448000000000000000000000000000000000000000000000000000000_Address
    );

    collateralJoin[RETH] =
      CollateralJoin(CollateralJoinChild_0x5245544800000000000000000000000000000000000000000000000000000000_Address);
    collateralAuctionHouse[RETH] = CollateralAuctionHouse(
      CollateralAuctionHouseChild_0x5245544800000000000000000000000000000000000000000000000000000000_Address
    );

    collateralJoin[MAGIC] =
      CollateralJoin(CollateralJoinChild_0x4d41474943000000000000000000000000000000000000000000000000000000_Address);
    collateralAuctionHouse[MAGIC] = CollateralAuctionHouse(
      CollateralAuctionHouseChild_0x4d41474943000000000000000000000000000000000000000000000000000000_Address
    );

    // --- jobs ---
    accountingJob = AccountingJob(AccountingJob_Address);
    liquidationJob = LiquidationJob(LiquidationJob_Address);
    oracleJob = OracleJob(OracleJob_Address);

    // --- governor ---
    timelockController = TimelockController(payable(TimelockController_Address));
    odGovernor = ODGovernor(payable(ODGovernor_Address));

    // --- proxies ---
    vault721 = Vault721(Vault721_Address);
    safeManager = ODSafeManager(ODSafeManager_Address);
    nftRenderer = NFTRenderer(NFTRenderer_Address);

    basicActions = BasicActions(BasicActions_Address);
    debtBidActions = DebtBidActions(DebtBidActions_Address);
    surplusBidActions = SurplusBidActions(SurplusBidActions_Address);
    collateralBidActions = CollateralBidActions(CollateralBidActions_Address);
    rewardedActions = RewardedActions(RewardedActions_Address);
    globalSettlementActions = GlobalSettlementActions(GlobalSettlementActions_Address);
    postSettlementSurplusBidActions = PostSettlementSurplusBidActions(PostSettlementSurplusBidActions_Address);

    // --- oracles ---
    systemCoinOracle = IBaseOracle(address(0));
    delayedOracle[ARB] = IDelayedOracle(DelayedOracleChild_ARB_Address);
    delayedOracle[WSTETH] = IDelayedOracle(DelayedOracleChild_WSTETH_Address);
    delayedOracle[CBETH] = IDelayedOracle(DelayedOracleChild_CBETH_Address);
    delayedOracle[RETH] = IDelayedOracle(DelayedOracleChild_RETH_Address);
    delayedOracle[MAGIC] = IDelayedOracle(DelayedOracleChild_MAGIC_Address);

    camelotV3Factory = ICamelotV3Factory(GOERLI_CAMELOT_V3_FACTORY);
  }
}
