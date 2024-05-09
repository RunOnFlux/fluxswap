import 'dart:typed_data';

import 'package:fluxswap/models/enums.dart';
import 'package:fluxswap/utils/base58.dart';
import 'package:fluxswap/utils/bech32.dart';
import 'package:web3dart/crypto.dart';
import 'package:validators/validators.dart';
import 'dart:convert';

bool isValidAddress(String address, NETWORKS network) {
  switch (network) {
    case NETWORKS.ETH:
    case NETWORKS.BSC:
    case NETWORKS.BASE:
    case NETWORKS.AVAX:
    case NETWORKS.MATIC:
      return isValidEthereumAddress(address);
    case NETWORKS.FLUX:
      return isValidFluxMainnetAddress(address);
    case NETWORKS.BTC:
      return isValidBitcoinAddress(address);

    default:
      return false;
  }
}

bool isValidEthereumAddress(String address) {
  // Check length and prefix
  if (address.length != 42 || !address.startsWith('0x')) {
    return false;
  }

  // Check if it's hexadecimal
  String hexPart = address.substring(2);
  if (!isHexadecimal(hexPart)) {
    return false;
  }

  // Check for checksum
  return isChecksumValid(address);
}

bool isChecksumValid(String address) {
  String addressLower = address.toLowerCase().substring(2);
  String hashedAddress = bytesToHex(keccak256(utf8.encode(addressLower)));

  for (int i = 0; i < 40; i++) {
    if (int.parse(hashedAddress[i], radix: 16) > 7 &&
        address[i + 2] != address[i + 2].toUpperCase()) {
      return false;
    }
    if (int.parse(hashedAddress[i], radix: 16) <= 7 &&
        address[i + 2] != address[i + 2].toLowerCase()) {
      return false;
    }
  }

  return true;
}

bool isValidFluxMainnetAddress(String address) {
  if (address.startsWith("t1") || address.startsWith("t3")) {
    return isValidBase58Address(address);
  }
  return false;
}

bool isValidBitcoinAddress(String address) {
  if (address.startsWith("1") || address.startsWith("3")) {
    return isValidBase58Address(address);
  } else if (address.startsWith("bc1")) {
    return isValidBech32Address(address);
  } else {
    return false;
  }
}

String toChecksumAddress(String address) {
  final hexAddress = address.toLowerCase().replaceFirst('0x', '');
  final hash = bytesToHex(keccak256(Uint8List.fromList(hexAddress.codeUnits)));

  String checksumAddress = '';
  for (int i = 0; i < hexAddress.length; i++) {
    final hexDigit = hexAddress[i];
    final intValue = int.parse(hash[i], radix: 16);
    checksumAddress += intValue >= 8 ? hexDigit.toUpperCase() : hexDigit;
  }
  return '0x$checksumAddress';
}
