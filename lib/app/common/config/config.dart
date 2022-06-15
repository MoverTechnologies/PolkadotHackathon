import 'package:flutter/material.dart';
import '../models/contract_model.dart';

import '../models/chain_model.dart';

class Config {
  static ChainModel get chain => astarChain;
  static ContractModel get paymentContract => payment;

  static ChainModel astarChain = ChainModel(
    name: "Astar Network",
    chainID: 592,
    rpcUrl: "https://evm.astar.network",
  );

  static ChainModel shibuyaChain = ChainModel(
    name: "Shibuya Network",
    chainID: 81,
    rpcUrl: "https://rpc.shibuya.astar.network:8545/",
  );

  static ContractModel payment = ContractModel(
    address: "0x0000000000000000000000000000000000000000",
    abiPath: "assets/abi/payment.json",
  );
}
