class Asset {
  final String idzelcore;
  final String ticker;
  final String name;
  final String chain;
  final String? contract;
  final String idsimpleswapfloat;
  final List<String> idsimpleswapfloatlimit;
  final String? idchangellyfloat;
  final List<String>? idchangellyfloatlimit;
  final String? idchangellyfix;
  final List<String>? idchangellyfixlimit;
  final String? idchangenowfloat;
  final List<String>? idchangenowfloatlimit;
  final String? idchangenowfix;
  final List<String>? idchangenowfixlimit;
  final String? idsimpleswapfix;
  final List<String>? idsimpleswapfixlimit;

  Asset({
    required this.idzelcore,
    required this.ticker,
    required this.name,
    required this.chain,
    this.contract,
    required this.idsimpleswapfloat,
    required this.idsimpleswapfloatlimit,
    this.idchangellyfloat,
    this.idchangellyfloatlimit,
    this.idchangellyfix,
    this.idchangellyfixlimit,
    this.idchangenowfloat,
    this.idchangenowfloatlimit,
    this.idchangenowfix,
    this.idchangenowfixlimit,
    this.idsimpleswapfix,
    this.idsimpleswapfixlimit,
  });

  factory Asset.fromJson(Map<String, dynamic> json) {
    return Asset(
      idzelcore: json['idzelcore'],
      ticker: json['ticker'],
      name: json['name'],
      chain: json['chain'],
      contract: json['contract'],
      idsimpleswapfloat: json['idsimpleswapfloat'],
      idsimpleswapfloatlimit: List<String>.from(json['idsimpleswapfloatlimit']),
      idchangellyfloat: json['idchangellyfloat'],
      idchangellyfloatlimit: json['idchangellyfloatlimit'] != null
          ? List<String>.from(json['idchangellyfloatlimit'])
          : null,
      idchangellyfix: json['idchangellyfix'],
      idchangellyfixlimit: json['idchangellyfixlimit'] != null
          ? List<String>.from(json['idchangellyfixlimit'])
          : null,
      idchangenowfloat: json['idchangenowfloat'],
      idchangenowfloatlimit: json['idchangenowfloatlimit'] != null
          ? List<String>.from(json['idchangenowfloatlimit'])
          : null,
      idchangenowfix: json['idchangenowfix'],
      idchangenowfixlimit: json['idchangenowfixlimit'] != null
          ? List<String>.from(json['idchangenowfixlimit'])
          : null,
      idsimpleswapfix: json['idsimpleswapfix'],
      idsimpleswapfixlimit: json['idsimpleswapfixlimit'] != null
          ? List<String>.from(json['idsimpleswapfixlimit'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idzelcore': idzelcore,
      'ticker': ticker,
      'name': name,
      'chain': chain,
      'contract': contract,
      'idsimpleswapfloat': idsimpleswapfloat,
      'idsimpleswapfloatlimit': idsimpleswapfloatlimit,
      'idchangellyfloat': idchangellyfloat,
      'idchangellyfloatlimit': idchangellyfloatlimit,
      'idchangellyfix': idchangellyfix,
      'idchangellyfixlimit': idchangellyfixlimit,
      'idchangenowfloat': idchangenowfloat,
      'idchangenowfloatlimit': idchangenowfloatlimit,
      'idchangenowfix': idchangenowfix,
      'idchangenowfixlimit': idchangenowfixlimit,
      'idsimpleswapfix': idsimpleswapfix,
      'idsimpleswapfixlimit': idsimpleswapfixlimit,
    };
  }
}
