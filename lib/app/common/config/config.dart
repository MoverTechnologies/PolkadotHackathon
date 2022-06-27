import '../models/contract_model.dart';

import '../models/chain_model.dart';

class Config {
  static ChainModel get chain => polygonMainnet;
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

  static String searchRpcUrl = "http://";
}
