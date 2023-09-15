// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.19;

abstract contract GoerliContracts {
address public ChainlinkRelayerFactoryAddr = 0xE2954DBFD2CeD40a42423CE45Bec71cddE62b238;
address public UniV3RelayerFactoryAddr = 0x6567e4B97d7b29E8450574cc791D1b285d53517f;
address public CamelotRelayerFactoryAddr = 0x9dF2e75A79f7d004Ee9e0561256D8218c08f7a28;
address public DelayedOracleFactoryAddr = 0x58aa678Cf064384773422013162af0b5A1Fe120C;
address public DenominatedOracleFactoryAddr = 0xDF3ec9aC07C22Cd547c7f3Af303f1aACcBdcfe68;

address public ChainlinkRelayerChild1Addr = 0xAE136Ab804Aa47253b0AFEc11F969cB3317578b6;
address public ChainlinkRelayerChild2Addr = 0x1cCFd1f257b24E910fB166DF3523E5268596910B;

address public MintableERC20WBTC = 0xF2Ef4Aba083b051e0Ba3bA9e9Fd7A221d77196ab;
address public MintableERC20STONES = 0x89E601690eeaE02adD447721C677f47A0F8a9BA6;
address public MintableERC20TOTEM = 0x0e7BD9EDe2f9c741C0c44812142c8Cd112a7a7c6;

address public OracleForTestnet1Addr = 0x6AAfbE1c150aa7589eB74aDc0a133aC82Db4faa5;
address public OracleForTestnet2Addr = 0x09162AF9Ac0CCE48Eb556B6F8A0D185AfA3FE431;
address public OracleForTestnet3Addr = 0xe90CCc8EB55e0046961b83bF42Cc8bDbD78C4536;
address public OracleForTestnet4Addr = 0x123A658A406745DE69f43bd5D4793F13d5FC4e71;

address public DenominatedOracleChild1Addr = 0xf6F02108C999475e8b7da723B2C8aC3e1416cd48;
address public DenominatedOracleChild2Addr = 0xB8cf2077C19975Ea04553D7571631f04062d2C87;
address public DenominatedOracleChild3Addr = 0x44F3AdD3be62E2f89E81DBeEa66CED795f090CD5;

address public DelayedOracleChild1Addr = 0x0d3046fB12985EC04F571a1f86aA41b5365eb4Fa;
address public DelayedOracleChild2Addr = 0x4C6abb08396A2192A86f9336F9f6aFc22896800d;
address public DelayedOracleChild3Addr = 0x07403323D089D07cf16b97F4661958a2eE9bAAAd;
address public DelayedOracleChild4Addr = 0x2b8eA7616F9bbeC5E01DB2E0a6FBA61b01895906;
address public DelayedOracleChild5Addr = 0x1170745Eea84d4Cfd67C89ADF631791A07759279;

address public SystemCoinAddr = 0xD10b0Bfbcc448b5A3ed925457C3cFb234fCc3260;
address public ProtocolTokenAddr = 0xFcC4fcbb3709F6bDe617303A762D80C763144335;

address public SAFEEngineAddr = 0x64199539aD6Dff2525EB1eaafBFe24556ACafC3c;
address public OracleRelayerAddr = 0x62b1061Efa5b9D397F06F7E463fa52521C2868E6;

address public SurplusAuctionHouseAddr = 0xf4D1fBA7154778B0C05B35c9740a47b15d92CD73;
address public DebtAuctionHouseAddr = 0x4cAA160730a9a419dF40a77B8655fFAE9b591bD1;
address public AccountingEngineAddr = 0x9c539e91d05aAD1d8Cc8644ca5F88510Be396b94;
address public LiquidationEngineAddr = 0x8C5311Dc5a1c801C337A0cfaE449062fCad8D0C5;

address public CollateralAuctionHouseFactory = 0x868676aE8f338aD0CdcDBfb2e419a72af614f1ef;
address public CoinJoin = 0x7C246D188D7DeFEda03C019d013c4fE0D0e92865;
address public CollateralJoinFactory = 0xd53F3F46fBDF7B5b33dd43850db2eebB86142105;
address public TaxCollector = 0x188d92c54f6Aa2917A5a09706A9f5D4ABB3d5bC3;
address public StabilityFeeTreasury = 0xB18e7b8F9637d662faee4F45186378a6d99F276e;
address public GlobalSettlement = 0x30c852abcA46fD285B085536B4472E4475941DAe;a
address public PostSettlementSurplusAuctionHouse = 0x72421E76e1058764000Cc3B884504fc4b2e2C876;/
address public SettlementSurplusAuctioneer = 0x0bCd50e8E12C5780B67e9403A9F1b41C080a14c1;	

address public PIDControllerAddr = 0x3938383a7708712841cB6d9771DFFB8099572638;
address public PIDRateSetterAddr = 0xcc6Ab006B3F9157eB83dc7f930cC0847D9B12199;

address public AccountingJobAddr = 0x558A41f026E43aBf32DE9a51F68B4038c9e8033b;
address public LiquidationJobAddr = 0x380ffcBA9496e8957208a593EC4bAEc58dC550e6;
address public OracleJobAddr = 0xdC47132176d9a84A40c1513679298CAff9F1943d;

address public CollateralJoinChild_WETHAddr = 0xcB47747FAE8cDA94BD3b116fd6eccda2230c18e4;
address public CollateralAuctionHouseChild_WETHAddr = 0xA122B4A2c914A631D05A649Ff4F9DF6bBf15aa37;
address public CollateralJoinDelegatableChild_FTRGAddr = 0x5152F1Ad53B18eAc6455F3d283813FF0D9a0f36b;
address public CollateralAuctionHouseChild_FTRGAddr = 0x94F2a0cee553d72184f4E2ed022f2bDD98f8F43A;
address public CollateralJoinChild_WBTCAddr = 0x03339fF818203769eBC8Ec46de8bCe17dd316cAC;
address public CollateralAuctionHouseChild_WBTCAddr = 0xe7269c8A7B22FCcAd121B723dC3b5a09D0F5Ca44;
address public CollateralJoinChild_STONESAddr = 0x8ec71Ac93185C004e72294FBF4B8C770145D2340;
address public CollateralAuctionHouseChild_STONESAddr = 0x9198A5C2BcB98c928e10Dd823101eEb6E91c75d7;
address public CollateralJoinChild_TOTEMAddr = 0x002130ffE70261F8d2fa2764896956115cB1147F;
address public CollateralAuctionHouseChild_TOTEMAddr = 0xf24b9C7D3b9DA2B17f30435b43df9d8167016Ea0;

address public Vault721Addr = 0x6FdDEFe31827fe38dCA0F9602e69a8eF92D125eB;
address public ODSafeManagerAddr = 0x46a197dF417691D367157fBD4793443db17cFc89;

address public DebtBidActionsAddr = 0x173EA59a3B886bBb69E934247C2A922089179263;
address public SurplusBidActionsAddr = 0x6E77bb046A155C08a29Ea85AA7d6e6256d227fBe;
address public CollateralBidActionsAddr = 0xed70aA833154801a9312e22dF9Be6Bada21BF0d5;
address public PostSettlementSurplusBidActionsAddr = 0x8b657341359F1D3A958d9a8735e65F08c5b60b4F;
address public RewardedActionsAddr = 0x6A243AAb287D39F299994e87A38Ba4Bc882246C1;
address public PostSettlementSurplusBidActionsAddr = 0xfee1cE339cAB37257DB110f98841A6B16CA31A91;

address public TimecontrollerAddr = 0x6d2065121c743238F3a827E0867136Fd956055f0;
}
