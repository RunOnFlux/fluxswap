import 'package:flutter_web3/flutter_web3.dart';
import 'package:fluxswap/models/contract_info.dart';
import 'package:fluxswap/models/enums.dart';
import 'package:fluxswap/models/metamask_network.dart';

const Map<NETWORKS, ContractInfo> Network_Details = {
  NETWORKS.FLUX: ContractInfo(
    chain: 0,
    contractAddress: "",
  ),
  NETWORKS.ETH: ContractInfo(
    chain: 1,
    contractAddress: "0x720CD16b011b987Da3518fbf38c3071d4F0D1495",
  ),
  NETWORKS.BSC: ContractInfo(
    chain: 56,
    contractAddress: "0xaFF9084f2374585879e8B434C399E29E80ccE635",
  ),
  NETWORKS.AVAX: ContractInfo(
    chain: 43114,
    contractAddress: "0xc4B06F17ECcB2215a5DBf042C672101Fc20daF55",
  ),
  NETWORKS.MATIC: ContractInfo(
    chain: 137,
    contractAddress: "0xA2bb7A68c46b53f6BbF6cC91C865Ae247A82E99B",
  ),
  NETWORKS.BASE: ContractInfo(
    chain: 8453,
    contractAddress: "0xb008bdcf9cdff9da684a190941dc3dca8c2cdd44",
  ),
};

ContractInfo getNetworkDetails(NETWORKS network) {
  return Network_Details[network]!;
}

Map<String, MetaMaskNetworkInfo> Metamask_Network_Info = {
  'Ethereum': MetaMaskNetworkInfo(
      imageName: '/images/eth-icon.svg',
      chainId: 1,
      currencyParams: CurrencyParams(name: 'ETH', symbol: 'ETH', decimals: 18),
      rpcurls: ['https://mainnet.infura.io/v3/'],
      blockexplorerurls: ['https://etherscan.io']),
  'BNB Chain': MetaMaskNetworkInfo(
      imageName: '/images/bnb-icon.svg',
      chainId: 56,
      currencyParams: CurrencyParams(name: 'BNB', symbol: 'BNB', decimals: 18),
      rpcurls: ['https://bsc-dataseed.binance.org/'],
      blockexplorerurls: ['https://bscscan.com/']),
  'Polygon': MetaMaskNetworkInfo(
      imageName: '/images/polygon-icon.svg',
      chainId: 137,
      currencyParams:
          CurrencyParams(name: 'MATIC', symbol: 'MATIC', decimals: 18),
      rpcurls: ['https://polygon-mainnet.infura.io'],
      blockexplorerurls: ['https://polygonscan.com/']),
  'Avalanche': MetaMaskNetworkInfo(
      imageName: '/images/avax-icon.svg',
      chainId: 43114,
      currencyParams:
          CurrencyParams(name: 'AVAX', symbol: 'AVAX', decimals: 18),
      rpcurls: ['https://api.avax.network/ext/bc/C/rpc'],
      blockexplorerurls: ['https://snowtrace.io/']),
  'Base': MetaMaskNetworkInfo(
      imageName: '/images/base-icon.svg',
      chainId: 8453,
      currencyParams: CurrencyParams(name: 'ETH', symbol: 'ETH', decimals: 18),
      rpcurls: ['https://mainnet.base.org'],
      blockexplorerurls: ['https://basescan.org']),
};
