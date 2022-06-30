import '../models/contract_model.dart';

import '../models/chain_model.dart';

class Config {
  static ChainModel get chain => mumbaiTestnet;
  static ContractModel get paymentContract => payment;

  static ChainModel astarmainnet = ChainModel(
    name: "Astar Mainnet",
    chainID: 592,
    rpcUrl: "https://evm.astar.network",
  );
  static ChainModel astarLocalnet = ChainModel(
    name: "AstarLocalnet",
    chainID: 4369,
    rpcUrl: "http://localhost:9933/",
  );
  static ChainModel shibuyaTestnet = ChainModel(
    name: "ShibuyaTestnet",
    chainID: 81,
    rpcUrl: "https://rpc.shibuya.astar.network:8545/",
    // rpcUrl: "https://shibuya.public.blastapi.io",
  );
  static ChainModel mumbaiTestnet = ChainModel(
    name: "MumbaiTestnet",
    chainID: 80001,
    rpcUrl: "https://rpc-mumbai.maticvigil.com/",
  );
  static ChainModel polygonMainnet = ChainModel(
    name: "Polygon Mainnet",
    chainID: 137,
    rpcUrl: "https://polygon-rpc.com",
  );

  static ContractModel payment = ContractModel(
    address: "0x0000000000000000000000000000000000000000",
  );

  //TODO add your contract models here!
  // static ContractModel provedContract = ContractModel(
  //   address: "0x0000000000000000000000000000000000000000", //astar
  //   // address: "0x0000000000000000000000000000000000000000", //polygon
  // );
  static ContractModel pomContract = ContractModel(
    // address: "0x088092767fa97E43f069C447d529e95be3CC6521", //astar
    // address: "0x5FC8d32690cc91D4c39d9d3abcBD16989F875707", //hardhat
    address: "0x0C21FEa1026A6d529E2DECf5604f55C4D16E813D", //mumbai
  );
  static ContractModel tokenContract = ContractModel(
    // address: "0x088092767fa97E43f069C447d529e95be3CC6521", //astar
    // address: "0x5FbDB2315678afecb367f032d93F642f64180aa3", //hardhat
    address: "0xe62F948912296611b4F2FEfA3517179492895c9C", //mumbai
  );
  static ContractModel vestingContract = ContractModel(
    // address: "0x088092767fa97E43f069C447d529e95be3CC6521", //astar
    // address: "0xCf7Ed3AccA5a467e9e704C703E8D87F634fB0Fc9", //hardhat
    address: "0x1D933E3d67a9ED692B027154Bb988a93EeA7DDc6", //mumbai
  );
  static ContractModel agreementContract = ContractModel(
    // address: "0x088092767fa97E43f069C447d529e95be3CC6521", //astar
    // address: "0xa513E6E4b8f2a923D98304ec87F64353C4D5C853", //hardhat
    address: "0xC7896Bf05ceA4d457Cff9FD14456Da2bC224dBb4", //mumbai
  );
// pom:0x9fE46736679d2D9a65F0992F2272dE9f3c7fa6e0
// token:0xCf7Ed3AccA5a467e9e704C703E8D87F634fB0Fc9
//   vessting:0x5FC8d32690cc91D4c39d9d3abcBD16989F875707
// agreement:0xa513E6E4b8f2a923D98304ec87F64353C4D5C853

  static String searchRpcUrl = "http://";
}
