import 'package:mover/models/EmploymentRequest.dart';
import 'package:mover/models/MoverUser.dart';

class ModModel {
  final MoverUser user; // from AWS Amplify Data Sync
  final ModRatingModel rating; // from SubQuery
  final List<EmploymentRequest>
      employmentRequests; // from AWS Amplify Data Sync

  ModModel(
      {required this.user,
      required this.rating,
      required this.employmentRequests});
}

class ModRatingModel {
  final double total;
  final int expDao;
  final bool isEns;

  toExpDaoString() {
    var _ret = "";
    if (expDao < 10) {
      _ret = "<10";
    } else if ((10 < expDao) && (expDao < 100)) {
      _ret = "+10";
    } else if (100 < expDao) {
      _ret = "+100";
    }
    return "$_ret Communities";
  }

  ModRatingModel(
      {required this.total, required this.expDao, required this.isEns});
}

class ModSearchRequestModel {
  ModSearchRequestModel();

  int daos = 0;
  bool hasEns = false;
}

final List<ModModel> statsModelsMockData = [
  ModModel(
      user: MoverUser(
        nickname: 'John Titor',
        email: '',
        iconUrl:
            'https://image.binance.vision/editor-uploads-original/9c15d9647b9643dfbc5e522299d13593.png',
        discordID: 'feay89y78@8967',
        wallet: '0x26d4640A76F6cAF8ff3fcDf34ea02219c983b1B9',
        firebaseTokenID: '',
        extended: '',
        languagesAsISO639: ["ja", "en"],
      ),
      rating: ModRatingModel(
        total: 4.5,
        expDao: 128,
        isEns: true,
      ),
      employmentRequests: [
        EmploymentRequest(
          employeeWallet: "0x1234567890123456789012345678901234567890",
          periodMonth: 3,
          dayPerMonth: 20,
          hourPerDay: 5,
          currency: "ASTR",
          price: 300,
        ),
        EmploymentRequest(
          employeeWallet: "0x1234567890123456789012345678901234567890",
          periodMonth: 2,
          dayPerMonth: 10,
          hourPerDay: 10,
          currency: "ASTR",
          price: 500,
        ),
        EmploymentRequest(
          employeeWallet: "0x1234567890123456789012345678901234567890",
          periodMonth: 3,
          dayPerMonth: 22,
          hourPerDay: 10,
          currency: "ASTR",
          price: 1200,
        ),
      ]),
  ModModel(
      user: MoverUser(
        nickname: 'John Titor',
        email: '',
        iconUrl:
            'https://image.binance.vision/editor-uploads-original/9c15d9647b9643dfbc5e522299d13593.png',
        discordID: 'feay89y78@8967',
        wallet: '0xF83F62CC6Ad13570263D12e692b8Ee7850F928ef',
        firebaseTokenID: '',
        extended: '',
        languagesAsISO639: ["ja", "en"],
      ),
      rating: ModRatingModel(
        total: 4.5,
        expDao: 128,
        isEns: true,
      ),
      employmentRequests: [
        EmploymentRequest(
          employeeWallet: "0x1234567890123456789012345678901234567890",
          periodMonth: 3,
          dayPerMonth: 20,
          hourPerDay: 5,
          currency: "ASTR",
          price: 300,
        ),
        EmploymentRequest(
          employeeWallet: "0x1234567890123456789012345678901234567890",
          periodMonth: 2,
          dayPerMonth: 10,
          hourPerDay: 10,
          currency: "ASTR",
          price: 500,
        ),
        EmploymentRequest(
          employeeWallet: "0x1234567890123456789012345678901234567890",
          periodMonth: 3,
          dayPerMonth: 22,
          hourPerDay: 10,
          currency: "ASTR",
          price: 1200,
        ),
      ]),
];
