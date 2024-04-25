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

/// Utility class to easily convert amounts of Ether into different units of
/// quantities.
class FluxAmount {
  const FluxAmount.inWei(this._value);

  FluxAmount.zero() : this.inWei(BigInt.zero);

  /// Constructs an amount of Ether by a unit and its amount. [amount] can
  /// either be a base10 string, an int or a BigInt.
  @Deprecated(
    'Please use fromInt, fromBigInt or fromBase10String.',
  )
  factory FluxAmount.fromUnitAndValue(FluxUnit unit, dynamic amount) {
    BigInt parsedAmount;

    if (amount is BigInt) {
      parsedAmount = amount;
    } else if (amount is int) {
      parsedAmount = BigInt.from(amount);
    } else if (amount is String) {
      parsedAmount = BigInt.parse(amount);
    } else {
      throw ArgumentError('Invalid type, must be BigInt, string or int');
    }

    return FluxAmount.inWei(parsedAmount * _factors[unit]!);
  }

  /// Constructs an amount of Ether by a unit and its amount.
  factory FluxAmount.fromInt(FluxUnit unit, int amount) {
    final wei = _factors[unit]! * BigInt.from(amount);

    return FluxAmount.inWei(wei);
  }

  /// Constructs an amount of Ether by a unit and its amount.
  factory FluxAmount.fromBigInt(FluxUnit unit, BigInt amount) {
    final wei = _factors[unit]! * amount;

    return FluxAmount.inWei(wei);
  }

  /// Constructs an amount of Ether by a unit and its amount.
  factory FluxAmount.fromBase10String(FluxUnit unit, String amount) {
    final wei = _factors[unit]! * BigInt.parse(amount);

    return FluxAmount.inWei(wei);
  }

  /// Gets the value of this amount in the specified unit as a whole number.
  /// **WARNING**: For all units except for [FluxUnit.wei], this method will
  /// discard the remainder occurring in the division, making it unsuitable for
  /// calculations or storage. You should store and process amounts of ether by
  /// using a BigInt storing the amount in wei.
  BigInt getValueInUnitBI(FluxUnit unit) => _value ~/ _factors[unit]!;

  static final Map<FluxUnit, BigInt> _factors = {
    FluxUnit.wei: BigInt.one,
    FluxUnit.kwei: BigInt.from(10).pow(3),
    FluxUnit.mwei: BigInt.from(10).pow(6),
    FluxUnit.gwei: BigInt.from(10).pow(9),
    FluxUnit.flux: BigInt.from(10).pow(8),
    FluxUnit.szabo: BigInt.from(10).pow(12),
    FluxUnit.finney: BigInt.from(10).pow(15),
    FluxUnit.ether: BigInt.from(10).pow(18),
  };

  final BigInt _value;

  BigInt get getInWei => _value;
  BigInt get getInEther => getValueInUnitBI(FluxUnit.ether);

  /// Gets the value of this amount in the specified unit. **WARNING**: Due to
  /// rounding errors, the return value of this function is not reliable,
  /// especially for larger amounts or smaller units. While it can be used to
  /// display the amount of ether in a human-readable format, it should not be
  /// used for anything else.
  double getValueInUnit(FluxUnit unit) {
    final factor = _factors[unit]!;
    final value = _value ~/ factor;
    final remainder = _value.remainder(factor);

    return value.toInt() + (remainder.toInt() / factor.toInt());
  }

  @override
  String toString() {
    return 'FluxAmount: $getInWei wei';
  }

  @override
  int get hashCode => getInWei.hashCode;

  @override
  bool operator ==(Object other) =>
      other is FluxAmount && other.getInWei == getInWei;
}
