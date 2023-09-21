const fs = require("fs");
const path = require("path");

const filePath = path.join(__dirname, "../script/GoerliContracts.s.sol");

fs.readFile(filePath, "utf8", (err, data) => {
  if (err) {
    console.error(err);
    return;
  }

  const onlyAddresses = data.split("Contracts {")[1].split("}")[0];
  const cleanedString = onlyAddresses
    .replace(/address public/g, "")
    .replace(/\n/g, "")
    .replace(/\s/g, "");
  // Split the string into lines
  const lines = cleanedString.split(";");

  // Create an empty object to store the converted values
  const contracts = {};
  // Iterate over each line and populate the output object
  lines.forEach((line) => {
    const [key, value] = line.split("=");
    contracts[key.trim()] = value?.trim();
  });

  createOutputFile(contracts);
});

const createOutputFile = (contracts) => {
  // VERIFY!!!
  const ETH_ADDRESS = "0xEe01c0CD76354C383B8c7B4e65EA88D00B06f36f";
  const final = {
    MULTICALL: "0xcA11bde05977b3631167028862bE2a173976CA11",
    ETH: ETH_ADDRESS,
    GEB_SYSTEM_COIN: contracts.SystemCoin_Address,
    GEB_PROTOCOL_TOKEN: contracts.ProtocolToken_Address,
    GEB_SAFE_ENGINE: contracts.SAFEEngine_Address,
    GEB_ORACLE_RELAYER: contracts.OracleRelayer_Address,
    GEB_SURPLUS_AUCTION_HOUSE: contracts.SurplusAuctionHouse_Address,
    GEB_DEBT_AUCTION_HOUSE: contracts.DebtAuctionHouse_Address,
    GEB_COLLATERAL_AUCTION_HOUSE_FACTORY:
      contracts.CollateralAuctionHouseFactory_Address,
    GEB_ACCOUNTING_ENGINE: contracts.AccountingEngine_Address,
    GEB_LIQUIDATION_ENGINE: contracts.LiquidationEngine_Address,
    GEB_COIN_JOIN: contracts.CoinJoin_Address,
    GEB_COLLATERAL_JOIN_FACTORY: contracts.CollateralJoinFactory_Address,
    GEB_TAX_COLLECTOR: contracts.TaxCollector_Address,
    GEB_STABILITY_FEE_TREASURY: contracts.StabilityFeeTreasury_Address,
    GEB_GLOBAL_SETTLEMENT: contracts.GlobalSettlement_Address,
    GEB_POST_SETTLEMENT_SURPLUS_AUCTION_HOUSE:
      contracts.PostSettlementSurplusAuctionHouse_Address,
    GEB_POST_SETTLEMENT_SURPLUS_AUCTIONEER:
      contracts.SettlementSurplusAuctioneer_Address,
    GEB_RRFM_SETTER: contracts.PIDRateSetter_Address,
    GEB_RRFM_CALCULATOR: contracts.PIDController_Address,
    SAFE_MANAGER: contracts.ODSafeManager_Address,
    GEB_GLOBAL_SETTLEMENT: contracts.GlobalSettlement_Address,
    PROXY_FACTORY: contracts.Vault721_Address,
    PROXY_BASIC_ACTIONS: contracts.BasicActions_Address,
    PROXY_REGISTRY: contracts.Vault721_Address,
    PROXY_DEBT_AUCTION_ACTIONS: contracts.DebtBidActions_Address,
    PROXY_SURPLUS_AUCTION_ACTIONS: contracts.SurplusBidActions_Address,
    PROXY_COLLATERAL_AUCTION_ACTIONS: contracts.CollateralBidActions_Address,
    PROXY_POST_SETTLEMENT_SURPLUS_AUCTION_ACTIONS:
      contracts.PostSettlementSurplusBidActions_Address,
    PROXY_GLOBAL_SETTLEMENT_ACTIONS: contracts.GlobalSettlementActions_Address,
    PROXY_REWARDED_ACTIONS: contracts.RewardedActions_Address,
    JOB_ACCOUNTING: contracts.AccountingJob_Address,
    JOB_LIQUIDATION: contracts.LiquidationJob_Address,
    JOB_ORACLES: contracts.OracleJob_Address,
  };

  const collateral = {
    OD: {
      address: contracts.SystemCoin_Address,
    },
    ODG: {
      address: contracts.ProtocolToken_Address,
    },
    WETH: {
      address: ETH_ADDRESS,
      collateralJoin:
        contracts.CollateralJoinChild_0x5745544800000000000000000000000000000000000000000000000000000000_Address,
      collateralAuctionHouse:
        contracts.CollateralAuctionHouseChild_0x5745544800000000000000000000000000000000000000000000000000000000_Address,
    },
    FTRG: {
      address: "0x0Ed89D4655b2fE9f99EaDC3116b223527165452D",
      collateralJoin:
        contracts.CollateralJoinChild_0x4654524700000000000000000000000000000000000000000000000000000000_Address,
      collateralAuctionHouse:
        contracts.CollateralAuctionHouseChild_0x4654524700000000000000000000000000000000000000000000000000000000_Address,
    },
    WBTC: {
      address: contracts.MintableERC20_WBTC_Address,
      collateralJoin:
        contracts.CollateralJoinChild_0x5742544300000000000000000000000000000000000000000000000000000000_Address,
      collateralAuctionHouse:
        contracts.CollateralAuctionHouseChild_0x5742544300000000000000000000000000000000000000000000000000000000_Address,
    },
    STN: {
      address: contracts.MintableERC20_STONES_Address,
      collateralJoin:
        contracts.CollateralJoinChild_0x53544f4e45530000000000000000000000000000000000000000000000000000_Address,
      collateralAuctionHouse:
        contracts.CollateralAuctionHouseChild_0x53544f4e45530000000000000000000000000000000000000000000000000000_Address,
    },
    TOTEM: {
      address: contracts.MintableERC20_TOTEM_Address,
      collateralJoin:
        contracts.CollateralJoinChild_0x544f54454d000000000000000000000000000000000000000000000000000000_Address,
      collateralAuctionHouse:
        contracts.CollateralAuctionHouseChild_0x544f54454d000000000000000000000000000000000000000000000000000000_Address,
    },
  };
  const validate = (obj) => {
    const missing = Object.values(obj).reduce((acc, curr, i) => {
      if (!curr) {
        acc.push(Object.keys(obj)[i]);
      }
      return acc;
    }, []);
    if (missing.length) throw `Missing values: ${missing.join(", ")}`;
  };

  validate(final);

  const outputPath = path.join(__dirname, "./output.js");
  const content = `// WARNING: You must verify the ETH address is still correct 
// which is used in both 'addresses' and 'collateral'


const addresses = ${JSON.stringify(final, null, 2)}
  
const collateral = ${JSON.stringify(collateral, null, 2)}`;

  fs.writeFile(outputPath, content, (err) => {
    if (err) {
      console.error(err);
      return;
    }

    console.log("output.js written to file successfully!");
  });
};
