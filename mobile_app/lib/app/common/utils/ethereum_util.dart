class EthereumUtil {
  // static double toEther({
  //   required BigInt fromWei,
  //   int decimals = 18,
  // }) {
  //   var unit = BigInt.from(10).pow(decimals);

  //   return fromWei / unit;
  // }

  static String weiToEth(String _wei) {
    const WEI_DIGIT = 18;

    return _xToEth(_wei, WEI_DIGIT);
  }

  static String mweiToEth(String _wei) {
    const WEI_DIGIT = 6;

    return _xToEth(_wei, WEI_DIGIT);
  }

  static String _xToEth(String _wei, int _decimal) {
    final WEI_DIGIT = _decimal;
    if (_wei.length <= WEI_DIGIT) {
      // wei is less than eth
      // if WEI_DIGIT(not WEI_DIGIT + 1), 123456789012345678 => .123456789012345678
      if (_wei[0] == "-") {
        _wei = _wei.substring(1);
      }
      _wei = _wei.padLeft(WEI_DIGIT + 1, "0");
    }

    return _wei.substring(0, _wei.length - WEI_DIGIT) +
        "." +
        _wei.substring(_wei.length - WEI_DIGIT);
  }
}
