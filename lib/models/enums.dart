enum WALLETS {
  METAMASK,
  WALLETCONNECT,
  ZELCORE,
  SSP,
}

// ignore: constant_identifier_names
enum NETWORKS {
  FLUX,
  ETH,
  BSC,
  AVAX,
  MATIC,
  BASE,
  BTC,
  SOL,
  TRX,
  KDA,
  ERG,
  ALGO
}

enum FluxUnit {
  /// Wei, the smallest and atomic amount of Ether
  wei,

  /// kwei, 1000 wei
  kwei,

  /// Mwei, one million wei
  mwei,

  /// Flux ^ 8
  flux,

  /// Gwei, one billion wei. Typically a reasonable unit to measure gas prices.
  gwei,

  /// szabo, 10^12 wei or 1 μEther
  szabo,

  /// finney, 10^15 wei or 1 mEther
  finney,

  /// 1 Ether
  ether,
}
