import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

const Color lightYellow = Color(0xFFFFF9C4);
const Color lightBlue = Color(0xFFB3E5FC);
const Color lightRed = Color(0xFFFFCDD2);
const Color lightGreen = Color(0xFFC8E6C9);
const Color lightPurple = Color(0xFFD1C4E9);

// API for coin svg file names - https://abe.zelcore.io/v1/zelcorecoins
class CoinLogos {
  static String? getLogoPath(String coin) {
    return logoPaths[coin];
  }

  Widget getImageWidget(String assetId) {
    String? path = CoinLogos.getLogoPath(assetId);
    path ??= 'assets/images/error.svg';

    if (path.endsWith('.svg')) {
      return SvgPicture.asset(
        path,
        width: 36,
        height: 36,
        allowDrawingOutsideViewBox: true,
        placeholderBuilder: (BuildContext context) =>
            CircularProgressIndicator(),
      );
    } else if (path.endsWith('.png')) {
      return Image.asset(
        path,
        width: 36,
        height: 36,
      );
    } else {
      return SvgPicture.asset(
        'assets/images/error.svg', // Fallback image for unsupported formats
        width: 36,
        height: 36,
      );
    }
  }

  static const Map<String, String> logoPaths = {
    "zelcash": "assets/logos/FLUX.svg",
    "testnet": "assets/logos/TESTFLUX.svg",
    "bitcoin": "assets/logos/BTC.svg",
    "bitcoinnativesegwit": "assets/logos/BTC.svg",
    "bitcointaproot": "assets/logos/BTC.svg",
    "ethereum": "assets/logos/ETH.svg",
    "litecoin": "assets/logos/LTC.svg",
    "litecoinnativesegwit": "assets/logos/LTC.svg",
    "litecointaproot": "assets/logos/LTC.svg",
    "zcash": "assets/logos/ZEC.svg",
    "bitcoinz": "assets/logos/BTCZ.svg",
    "ravencoin": "assets/logos/RVN.svg",
    "bitcore": "assets/logos/BTX.svg",
    "hush": "assets/logos/HUSH.svg",
    "binance": "assets/logos/BNB.svg",
    "sonm": "assets/logos/SONM.svg",
    "omisego": "assets/logos/OMG.svg",
    "zilliqa": "assets/logos/ZIL.svg",
    "zrx": "assets/logos/ZRX.svg",
    "golem": "assets/logos/GNT.svg",
    "kucoin": "assets/logos/KCS.svg",
    "bat": "assets/logos/BAT.svg",
    "maker": "assets/logos/MKR.svg",
    "kyber": "assets/logos/KNCL.svg",
    "enigma": "assets/logos/ENG.svg",
    "tenx": "assets/logos/PAY.svg",
    "substratum": "assets/logos/SUB.svg",
    "civic": "assets/logos/CVC.svg",
    "stox": "assets/logos/STX.svg",
    "bitcoingold": "assets/logos/BTG.svg",
    "snowgem": "assets/logos/TENT.svg",
    "gemlink": "assets/logos/GEMLINK.svg",
    "btcp": "assets/logos/BTCP.svg",
    "anon": "assets/logos/ANON.svg",
    "zen": "assets/logos/ZEN.svg",
    "safecoin": "assets/logos/SAFE.svg",
    "komodo": "assets/logos/KMD.svg",
    "zcoin": "assets/logos/FIRO.svg",
    "usdt": "assets/logos/USDT.svg",
    "zero": "assets/logos/ZER.svg",
    "bitcoincash": "assets/logos/BCH.svg",
    "arcblock": "assets/logos/ABT.svg",
    "adex": "assets/logos/ADX.svg",
    "aeternity": "assets/logos/AE.svg",
    "airswap": "assets/logos/AST.svg",
    "bigbom": "assets/logos/BBO.svg",
    "appcoins": "assets/logos/APPC.svg",
    "bluzelle": "assets/logos/BLZ.svg",
    "bancor": "assets/logos/BNT.svg",
    "coinfi": "assets/logos/COFI.svg",
    "dai": "assets/logos/SAI.svg",
    "digixgoldtoken": "assets/logos/DGX.svg",
    "electrify": "assets/logos/ELEC.svg",
    "aelf": "assets/logos/ELF.svg",
    "enjincoin": "assets/logos/ENJ.svg",
    "storj": "assets/logos/STORJ.svg",
    "iost": "assets/logos/IOST.svg",
    "dent": "assets/logos/DENT.svg",
    "ethlend": "assets/logos/LEND.svg",
    "chainlink": "assets/logos/LINK.svg",
    "decentraland": "assets/logos/MANA.svg",
    "loopring": "assets/logos/LRC.svg",
    "qash": "assets/logos/QASH.svg",
    "iconomi": "assets/logos/ICN.svg",
    "mco": "assets/logos/MCO.svg",
    "poet": "assets/logos/POE.svg",
    "polymath": "assets/logos/POLY.svg",
    "powerledger": "assets/logos/POWR.svg",
    "ripiocredit": "assets/logos/RCN.svg",
    "raidentoken": "assets/logos/RDN.svg",
    "requestnetwork": "assets/logos/REQ.svg",
    "status": "assets/logos/SNT.svg",
    "salt": "assets/logos/SALT.svg",
    "storm": "assets/logos/STORM.svg",
    "eidoo": "assets/logos/EDO.svg",
    "trueusd": "assets/logos/TUSD.svg",
    "dentacoin": "assets/logos/DCN.svg",
    "wax": "assets/logos/WAX.svg",
    "wings": "assets/logos/WINGS.svg",
    "data": "assets/logos/DTA.svg",
    "funfair": "assets/logos/FUN.svg",
    "kin": "assets/logos/KIN.svg",
    "zclassic": "assets/logos/ZCL.svg",
    "sirin": "assets/logos/SRN.svg",
    "aurora": "assets/logos/AOA.svg",
    "theta": "assets/logos/THETA.svg",
    "dash": "assets/logos/DASH.svg",
    "monero": "assets/logos/XMR.svg",
    "usdc": "assets/logos/USDC.svg",
    "gusd": "assets/logos/GUSD.svg",
    "pax": "assets/logos/PAX.svg",
    "etc": "assets/logos/ETC.svg",
    "coni": "assets/logos/CONI.svg",
    "tok": "assets/logos/TOK.svg",
    "genesis": "assets/logos/GENX.svg",
    "por": "assets/logos/POR.svg",
    "bzedge": "assets/logos/BZE.svg",
    "bithereum": "assets/logos/BTH.svg",
    "adt": "assets/logos/ADT.svg",
    "mft": "assets/logos/MFT.svg",
    "atl": "assets/logos/ATL.svg",
    "ant": "assets/logos/ANT.svg",
    "arn": "assets/logos/ARN.svg",
    "brd": "assets/logos/BRD.svg",
    "rep": "assets/logos/REP.svg",
    "qkc": "assets/logos/QKC.svg",
    "loom": "assets/logos/LOOM.svg",
    "eurs": "assets/logos/EURS.svg",
    "commercium": "assets/logos/CMM.svg",
    "groestlcoin": "assets/logos/GRS.svg",
    "gunthy": "assets/logos/GUNTHY.svg",
    "metal": "assets/logos/MTL.svg",
    "ethos": "assets/logos/ETHOS.svg",
    "singularitynet": "assets/logos/AGI.svg",
    "ambrosus": "assets/logos/AMB.svg",
    "blockmasoncreditprotocol": "assets/logos/BCPT.svg",
    "blox": "assets/logos/CDT.svg",
    "celertoken": "assets/logos/CELR.svg",
    "cindicator": "assets/logos/CND.svg",
    "streamrdatacoin": "assets/logos/DATA.svg",
    "agrello": "assets/logos/DLT.svg",
    "dock": "assets/logos/DOCK.svg",
    "everex": "assets/logos/EVX.svg",
    "gifto": "assets/logos/GTO.svg",
    "genesisvision": "assets/logos/GVT.svg",
    "holotoken": "assets/logos/HOT.svg",
    "insolar": "assets/logos/INS.svg",
    "iotex": "assets/logos/IOTX.svg",
    "selfkey": "assets/logos/KEY.svg",
    "lunyr": "assets/logos/LUN.svg",
    "monetha": "assets/logos/MTH.svg",
    "oax": "assets/logos/OAX.svg",
    "ost": "assets/logos/OST.svg",
    "populous": "assets/logos/PPT.svg",
    "quantstamp": "assets/logos/QSP.svg",
    "ren": "assets/logos/REN.svg",
    "iexecrlc": "assets/logos/RLC.svg",
    "singulardtv": "assets/logos/SNGLS.svg",
    "tierion": "assets/logos/TNT.svg",
    "viberate": "assets/logos/VIB.svg",
    "vibe": "assets/logos/VIBE.svg",
    "tael": "assets/logos/WABI.svg",
    "wepower": "assets/logos/WPR.svg",
    "dibicoin": "assets/logos/DIBI.svg",
    "bitcoinzero": "assets/logos/BZX.svg",
    "etherparty": "assets/logos/FUEL.svg",
    "bnbbinance": "assets/logos/BNB.svg",
    "ripple": "assets/logos/XRP.svg",
    "axe": "assets/logos/AXE.svg",
    "unussedleo": "assets/logos/LEO.svg",
    "beaxy": "assets/logos/BXY.svg",
    "stableusd": "assets/logos/USDS.svg",
    "nuke": "assets/logos/NUKE.svg",
    "eos": "assets/logos/EOS.svg",
    "dogecoin": "assets/logos/DOGE.svg",
    "digibyte": "assets/logos/DGB.svg",
    "digibytenativesegwit": "assets/logos/DGB.svg",
    "sinovate": "assets/logos/SIN.svg",
    "neo": "assets/logos/NEO.svg",
    "gas": "assets/logos/GAS.svg",
    "neofish": "assets/logos/NEO.svg",
    "stellar": "assets/logos/XLM.svg",
    "tron": "assets/logos/TRX.svg",
    "bittorrent": "assets/logos/BTT.svg",
    "gcstar": "assets/logos/GCSTAR.svg",
    "gctgt": "assets/logos/GCTGT.svg",
    "gcwal": "assets/logos/GCWAL.svg",
    "gcbest": "assets/logos/GCBEST.svg",
    "gchd": "assets/logos/GCHD.svg",
    "gclowe": "assets/logos/GCLOWE.svg",
    "ontology": "assets/logos/ONT.svg",
    "ontologygas": "assets/logos/ONG.svg",
    "dmme": "assets/logos/DMME.svg",
    "veriblock": "assets/logos/VBK.svg",
    "huobitoken": "assets/logos/HT.svg",
    "busd": "assets/logos/BUSD.svg",
    "okb": "assets/logos/OKB.svg",
    "bitforextoken": "assets/logos/BF.svg",
    "mxtoken": "assets/logos/MX.svg",
    "zbtoken": "assets/logos/ZB.svg",
    "hotbittoken": "assets/logos/HTB.svg",
    "huobipooltoken": "assets/logos/HPT.svg",
    "golfcoin": "assets/logos/GOLF.svg",
    "enecuum": "assets/logos/ENQ.svg",
    "fantom": "assets/logos/FTM.svg",
    "zeroxbitcoin": "assets/logos/0xBTC.svg",
    "vayla": "assets/logos/VYA.svg",
    "aergo": "assets/logos/AERGO.svg",
    "lunchmoney": "assets/logos/LMY.svg",
    "kadena": "assets/logos/KDA.svg",
    "netkoin": "assets/logos/NTK.svg",
    "gammacoin": "assets/logos/GMC.svg",
    "bazookatoken": "assets/logos/BAZ.svg",
    "coinsto": "assets/logos/CSO.svg",
    "unibright": "assets/logos/UBT.svg",
    "usdterc": "assets/logos/USDT.svg",
    "ilcoin": "assets/logos/ILC.svg",
    "hex": "assets/logos/HEX.svg",
    "comp": "assets/logos/COMP.svg",
    "vidt": "assets/logos/VIDT.svg",
    "drgn": "assets/logos/DRGN.svg",
    "whale": "assets/logos/WHALE.svg",
    "wbtc": "assets/logos/WBTC.svg",
    "genesistron": "assets/logos/GENX.svg",
    "om": "assets/logos/OM.svg",
    "testnetbitcoin": "assets/logos/TESTBTC.svg",
    "testnetbitcoinnativesegwit": "assets/logos/TESTBTC.svg",
    "testnetbitcointaproot": "assets/logos/TESTBTC.svg",
    "coinartisttoken": "assets/logos/COIN.svg",
    "uni": "assets/logos/UNI.svg",
    "testnetsepoliaethereum": "assets/logos/TESTETH.svg",
    "jst": "assets/logos/JST.svg",
    "beldex": "assets/logos/BDX.svg",
    "rvnnahan": "assets/logos/RVNNAHAN.svg",
    "toshi": "assets/logos/TOSHI.svg",
    "maid": "assets/logos/MAID.svg",
    "btcb": "assets/logos/BTCB.svg",
    "rune": "assets/logos/RUNE.svg",
    "usdttrc": "assets/logos/USDT.svg",
    "trueusdbnb": "assets/logos/TUSD.svg",
    "busdbnb": "assets/logos/BUSD.svg",
    "nexo": "assets/logos/NEXO.svg",
    "nexobnb": "assets/logos/NEXO.svg",
    "mcdai": "assets/logos/DAI.svg",
    "xdai": "assets/logos/STAKE.svg",
    "rev": "assets/logos/REV.svg",
    "revtrc": "assets/logos/REV.svg",
    "aave": "assets/logos/AAVE.svg",
    "snx": "assets/logos/SNX.svg",
    "yfi": "assets/logos/YFI.svg",
    "ftt": "assets/logos/FTT.svg",
    "grt": "assets/logos/GRT.svg",
    "sushi": "assets/logos/SUSHI.svg",
    "cel": "assets/logos/CEL.svg",
    "cro": "assets/logos/CRO.svg",
    "uma": "assets/logos/UMA.svg",
    "renbtc": "assets/logos/RENBTC.svg",
    "chsb": "assets/logos/CHSB.svg",
    "ampl": "assets/logos/AMPL.svg",
    "rsr": "assets/logos/RSR.svg",
    "ust": "assets/logos/UST.svg",
    "hedg": "assets/logos/HEDG.svg",
    "qnt": "assets/logos/QNT.svg",
    "ocean": "assets/logos/OCEAN.svg",
    "husd": "assets/logos/HUSD.svg",
    "cvt": "assets/logos/CVT.svg",
    "gno": "assets/logos/GNO.svg",
    "chzbnb": "assets/logos/CHZ.svg",
    "chz": "assets/logos/CHZ.svg",
    "suntrc": "assets/logos/SUN.svg",
    "usdjtrc": "assets/logos/USDJ.svg",
    "nxm": "assets/logos/NXM.svg",
    "dot": "assets/logos/DOT.svg",
    "testnetwnd": "assets/logos/TESTWND.svg",
    "testnetkadena": "assets/logos/TESTKDA.svg",
    "ksm": "assets/logos/KSM.svg",
    "inch": "assets/logos/1INCH.png",
    "cardano": "assets/logos/ADA.svg",
    "matic": "assets/logos/MATIC.svg",
    "bscbinance": "assets/logos/BNB.svg",
    "pancakeswap": "assets/logos/CAKE.svg",
    "arnx": "assets/logos/ARNX.svg",
    "bsceth": "assets/logos/ETH.svg",
    "bscusdt": "assets/logos/USDT.svg",
    "bscwbnb": "assets/logos/BNB.svg",
    "xcm": "assets/logos/XCM.svg",
    "fluxkda": "assets/logos/FLUX.svg",
    "gatetoken": "assets/logos/GT.svg",
    "knc": "assets/logos/KNC.svg",
    "pre": "assets/logos/PRE.svg",
    "solana": "assets/logos/SOL.svg",
    "wrappedsolana": "assets/logos/WSOL.svg",
    "serum": "assets/logos/SRM.svg",
    "megaserum": "assets/logos/MSRM.svg",
    "cope": "assets/logos/COPE.svg",
    "bonfida": "assets/logos/FIDA.svg",
    "fttsol": "assets/logos/FTT.svg",
    "kinsol": "assets/logos/KIN.svg",
    "maps": "assets/logos/MAPS.svg",
    "media": "assets/logos/MEDIA.svg",
    "oxy": "assets/logos/OXY.svg",
    "ray": "assets/logos/RAY.svg",
    "step": "assets/logos/STEP.svg",
    "usdcsol": "assets/logos/USDC.svg",
    "usdtsol": "assets/logos/USDT.svg",
    "ropesol": "assets/logos/ROPE.svg",
    "fluxeth": "assets/logos/FLUX.svg",
    "fluxbsc": "assets/logos/FLUX.svg",
    "mersol": "assets/logos/MER.svg",
    "tulipsol": "assets/logos/TULIP.svg",
    "alephsol": "assets/logos/ALEPH.svg",
    "busdbsc": "assets/logos/BUSD.svg",
    "suntrcb": "assets/logos/SUN.svg",
    "safemoonbep": "assets/logos/SAFEMOON.svg",
    "safemoonerc": "assets/logos/SAFEMOON.svg",
    "huplife": "assets/logos/HUP.svg",
    "raptoreum": "assets/logos/RTM.svg",
    "vertcoin": "assets/logos/VTC.svg",
    "btcbbsc": "assets/logos/BTCB.svg",
    "axserc": "assets/logos/AXS.svg",
    "bttbsc": "assets/logos/BTT.svg",
    "steth": "assets/logos/STETH.svg",
    "amp": "assets/logos/AMP.svg",
    "telcoin": "assets/logos/TELCOIN.svg",
    "harmonyone": "assets/logos/HARMONYONE.svg",
    "bscada": "assets/logos/ADA.svg",
    "bscxrp": "assets/logos/XRP.svg",
    "bscdoge": "assets/logos/DOGE.svg",
    "bscusdc": "assets/logos/USDC.svg",
    "bscdot": "assets/logos/DOT.svg",
    "bscuni": "assets/logos/UNI.svg",
    "bscbch": "assets/logos/BCH.svg",
    "bscltc": "assets/logos/LTC.svg",
    "bsclink": "assets/logos/LINK.svg",
    "bscetc": "assets/logos/ETC.svg",
    "bscavax": "assets/logos/AVAX.svg",
    "bscdai": "assets/logos/DAI.svg",
    "bsctrx": "assets/logos/TRX.svg",
    "bsceos": "assets/logos/EOS.svg",
    "bscatom": "assets/logos/ATOM.svg",
    "bscaxs": "assets/logos/AXS.svg",
    "bscxtz": "assets/logos/XTZ.svg",
    "bscmkr": "assets/logos/MKR.svg",
    "bscshib": "assets/logos/SHIB.svg",
    "bsciota": "assets/logos/IOTA.svg",
    "bsccomp": "assets/logos/COMP.svg",
    "bsczec": "assets/logos/ZEC.svg",
    "bsctusd": "assets/logos/TUSD.svg",
    "bsctusdold": "assets/logos/TUSD.svg",
    "bsczil": "assets/logos/ZIL.svg",
    "bscsnx": "assets/logos/SNX.svg",
    "bscyfi": "assets/logos/YFI.svg",
    "bscnear": "assets/logos/NEAR.svg",
    "bscbat": "assets/logos/BAT.svg",
    "bscftm": "assets/logos/FTM.svg",
    "bscbnt": "assets/logos/BNT.svg",
    "bscpax": "assets/logos/PAX.svg",
    "bscont": "assets/logos/ONT.svg",
    "bsccnineeight": "assets/logos/C98.svg",
    "bscankr": "assets/logos/ANKR.svg",
    "bscsxp": "assets/logos/SXP.svg",
    "bsciotx": "assets/logos/IOTX.svg",
    "bscwrx": "assets/logos/WRX.svg",
    "bscinch": "assets/logos/1INCH.png",
    "bscbake": "assets/logos/BAKE.svg",
    "bscalpha": "assets/logos/ALPHA.svg",
    "waveseth": "assets/logos/WAVES.svg",
    "shibeth": "assets/logos/SHIB.svg",
    "perpeth": "assets/logos/PERP.svg",
    "audioeth": "assets/logos/AUDIO.svg",
    "crveth": "assets/logos/CRV.svg",
    "sandeth": "assets/logos/SAND.svg",
    "vgxeth": "assets/logos/VGX.svg",
    "ankreth": "assets/logos/ANKR.svg",
    "sxpeth": "assets/logos/SXP.svg",
    "alphaeth": "assets/logos/ALPHA.svg",
    "feteth": "assets/logos/FET.svg",
    "glmeth": "assets/logos/GLM.svg",
    "usdneth": "assets/logos/USDN.svg",
    "skleth": "assets/logos/SKL.svg",
    "nmreth": "assets/logos/NMR.svg",
    "srmeth": "assets/logos/SRM.svg",
    "lpteth": "assets/logos/LPT.svg",
    "aliceeth": "assets/logos/ALICE.svg",
    "feieth": "assets/logos/FEI.svg",
    "ogneth": "assets/logos/OGN.svg",
    "injeth": "assets/logos/INJ.svg",
    "agixeth": "assets/logos/AGIX.svg",
    "paxgeth": "assets/logos/PAXG.svg",
    "bandeth": "assets/logos/BAND.svg",
    "stmxeth": "assets/logos/STMX.svg",
    "strxeth": "assets/logos/STMX.svg",
    "reefeth": "assets/logos/REEF.svg",
    "ctsieth": "assets/logos/CTSI.svg",
    "nkneth": "assets/logos/NKN.svg",
    "maticpolygon": "assets/logos/MATIC.svg",
    "wethpoly": "assets/logos/WETH.svg",
    "usdtpoly": "assets/logos/USDT.svg",
    "usdcpoly": "assets/logos/USDC.svg",
    "usdccirclepoly": "assets/logos/USDC.svg",
    "quickpoly": "assets/logos/QUICK.svg",
    "unipoly": "assets/logos/UNI.svg",
    "linkpoly": "assets/logos/LINK.svg",
    "wbtcpoly": "assets/logos/WBTC.svg",
    "daipoly": "assets/logos/DAI.svg",
    "aavepoly": "assets/logos/AAVE.svg",
    "sushipoly": "assets/logos/SUSHI.svg",
    "snxpoly": "assets/logos/SNX.svg",
    "telpoly": "assets/logos/TEL.svg",
    "nexopoly": "assets/logos/NEXO.svg",
    "ubtpoly": "assets/logos/UBT.svg",
    "wrxpoly": "assets/logos/WRX.svg",
    "ctsipoly": "assets/logos/CTSI.svg",
    "woopoly": "assets/logos/WOO.svg",
    "fishpoly": "assets/logos/FISH.svg",
    "hexpoly": "assets/logos/HEX.svg",
    "ompoly": "assets/logos/OM.svg",
    "kncpoly": "assets/logos/KNC.svg",
    "tribeeth": "assets/logos/TRIBE.svg",
    "bscprom": "assets/logos/PROM.svg",
    "godseth": "assets/logos/GODS.svg",
    "bscore": "assets/logos/ORE.svg",
    "pbxeth": "assets/logos/PBX.svg",
    "straxeth": "assets/logos/STRAX.svg",
    "ewteth": "assets/logos/EWT.svg",
    "prometh": "assets/logos/PROM.svg",
    "wooeth": "assets/logos/WOO.svg",
    "cotieth": "assets/logos/COTI.svg",
    "oxteth": "assets/logos/OXT.svg",
    "tomoeth": "assets/logos/TOMO.svg",
    "orbseth": "assets/logos/ORBS.svg",
    "uoseth": "assets/logos/UOS.svg",
    "badgereth": "assets/logos/BADGER.svg",
    "phaeth": "assets/logos/PHA.svg",
    "mvleth": "assets/logos/MVL.svg",
    "nueth": "assets/logos/NU.svg",
    "anteth": "assets/logos/ANT.svg",
    "dodoeth": "assets/logos/DODO.svg",
    "xyoeth": "assets/logos/XYO.svg",
    "utketh": "assets/logos/UTK.svg",
    "yfiieth": "assets/logos/YFII.svg",
    "mlneth": "assets/logos/MLN.svg",
    "baleth": "assets/logos/BAL.svg",
    "boraeth": "assets/logos/BORA.svg",
    "strketh": "assets/logos/STRK.svg",
    "snmeth": "assets/logos/SNM.svg",
    "adxeth": "assets/logos/ADX.svg",
    "loometh": "assets/logos/LOOM.svg",
    "dataeth": "assets/logos/DATA.svg",
    "aergoeth": "assets/logos/AERGO.svg",
    "videth": "assets/logos/VID.svg",
    "ometh": "assets/logos/OM.svg",
    "oxyeth": "assets/logos/OXY.svg",
    "rayeth": "assets/logos/RAY.svg",
    "alepheth": "assets/logos/ALEPH.svg",
    "c98eth": "assets/logos/C98.svg",
    "wetheth": "assets/logos/WETH.svg",
    "quicketh": "assets/logos/QUICK.svg",
    "dydxeth": "assets/logos/DYDX.svg",
    "xdbeth": "assets/logos/XDB.svg",
    "vlxeth": "assets/logos/VLX.svg",
    "fxeth": "assets/logos/FX.svg",
    "asdeth": "assets/logos/ASD.svg",
    "crwnyeth": "assets/logos/CRWNY.svg",
    "linksol": "assets/logos/LINK.svg",
    "sushisol": "assets/logos/SUSHI.svg",
    "woosol": "assets/logos/WOO.svg",
    "c98sol": "assets/logos/C98.svg",
    "samosol": "assets/logos/SAMO.svg",
    "mngosol": "assets/logos/MNGO.svg",
    "atlassol": "assets/logos/ATLAS.svg",
    "polissol": "assets/logos/POLIS.svg",
    "orcasol": "assets/logos/ORCA.svg",
    "aurysol": "assets/logos/AURY.svg",
    "slndsol": "assets/logos/SLND.svg",
    "sbrsol": "assets/logos/SBR.svg",
    "liqsol": "assets/logos/LIQ.svg",
    "snysol": "assets/logos/SNY.svg",
    "portsol": "assets/logos/PORT.svg",
    "abrsol": "assets/logos/ABR.svg",
    "crpsol": "assets/logos/CRP.svg",
    "ivnsol": "assets/logos/IVN.svg",
    "grapesol": "assets/logos/GRAPE.svg",
    "ninjasol": "assets/logos/NINJA.svg",
    "fluxtrx": "assets/logos/FLUX.svg",
    "crwnysol": "assets/logos/CRWNY.svg",
    "fluxsol": "assets/logos/FLUX.svg",
    "safemoonv2bep": "assets/logos/SAFEMOON.svg",
    "msolsol": "assets/logos/MSOL.svg",
    "stsolsol": "assets/logos/STSOL.svg",
    "slimsol": "assets/logos/SLIM.svg",
    "dflsol": "assets/logos/DFL.svg",
    "insol": "assets/logos/IN.svg",
    "jetsol": "assets/logos/JET.svg",
    "dxlsol": "assets/logos/DXL.svg",
    "likesol": "assets/logos/LIKE.svg",
    "mndesol": "assets/logos/MNDE.svg",
    "whapisol": "assets/logos/WHAPI.svg",
    "rinsol": "assets/logos/RIN.svg",
    "cyssol": "assets/logos/CYS.svg",
    "fabsol": "assets/logos/FAB.svg",
    "wagsol": "assets/logos/WAG.svg",
    "molasol": "assets/logos/MOLA.svg",
    "soldsol": "assets/logos/SOLD.svg",
    "catosol": "assets/logos/CATO.svg",
    "cstrsol": "assets/logos/CSTR.svg",
    "saosol": "assets/logos/SAO.svg",
    "apyssol": "assets/logos/APYS.svg",
    "sunnysol": "assets/logos/SUNNY.svg",
    "kurosol": "assets/logos/KURO.svg",
    "babena": "assets/logos/BABENA.svg",
    "fio": "assets/logos/FIO.svg",
    "kdlaunch": "assets/logos/KDL.svg",
    "rvnseedmoney": "assets/logos/RVNSEEDMONEY.svg",
    "smtfbep": "assets/logos/SMTF.svg",
    "lunaterra": "assets/logos/LUNA.svg",
    "ustterra": "assets/logos/UST.svg",
    "sdtterra": "assets/logos/SDT.svg",
    "krtterra": "assets/logos/KRT.svg",
    "mamznterra": "assets/logos/MAMZN.svg",
    "maaplterra": "assets/logos/MAAPL.svg",
    "mabnbterra": "assets/logos/MABNB.svg",
    "mcointerra": "assets/logos/MCOIN.svg",
    "mmsftterra": "assets/logos/MMSFT.svg",
    "mgooglterra": "assets/logos/MGOOGL.svg",
    "mtslaterra": "assets/logos/MTSLA.svg",
    "mtwtrterra": "assets/logos/MTWTR.svg",
    "mnflxterra": "assets/logos/MNFLX.svg",
    "saito": "assets/logos/SAITO.svg",
    "bittorrenttron": "assets/logos/BTT.svg",
    "bittorrenteth": "assets/logos/BTT.svg",
    "bittorrentbsc": "assets/logos/BTT.svg",
    "egldbsc": "assets/logos/EGLD.svg",
    "xhteth": "assets/logos/XHT.svg",
    "backalleykda": "assets/logos/BKA.svg",
    "kdswapkda": "assets/logos/KDS.svg",
    "avaxavalanchex": "assets/logos/AVAXX.svg",
    "avaxavalanchec": "assets/logos/AVAXC.svg",
    "avaxavalanchep": "assets/logos/AVAXP.svg",
    "ausdc": "assets/logos/USDC.svg",
    "usdce": "assets/logos/USDC.svg",
    "ausdt": "assets/logos/USDT.svg",
    "usdte": "assets/logos/USDT.svg",
    "wethe": "assets/logos/WETH.svg",
    "wbtce": "assets/logos/WBTC.svg",
    "daie": "assets/logos/DAI.svg",
    "linke": "assets/logos/LINK.svg",
    "wavax": "assets/logos/AVAX.svg",
    "joe": "assets/logos/JOE.svg",
    "qi": "assets/logos/QI.svg",
    "savax": "assets/logos/SAVAX.svg",
    "yusd": "assets/logos/YUSD.svg",
    "mokkda": "assets/logos/MOK.svg",
    "usdctrc": "assets/logos/USDC.svg",
    "fluxavax": "assets/logos/FLUX.svg",
    "kdx": "assets/logos/KDX.svg",
    "skdx": "assets/logos/SKDX.svg",
    "ergo": "assets/logos/ERG.svg",
    "fluxerg": "assets/logos/FLUX.svg",
    "sigmausd": "assets/logos/SIGUSD.svg",
    "sigmarsv": "assets/logos/SIGRSV.svg",
    "erdoge": "assets/logos/ERDOGE.svg",
    "ergopad": "assets/logos/ERGOPAD.svg",
    "paideia": "assets/logos/PAIDEIA.svg",
    "ergoland": "assets/logos/EXLE.svg",
    "egio": "assets/logos/EGIO.svg",
    "comet": "assets/logos/COMET.svg",
    "noweth": "assets/logos/NOW.svg",
    "nowbnb": "assets/logos/NOW.svg",
    "rsrerc": "assets/logos/RSR.svg",
    "karateerc": "assets/logos/KARATE.svg",
    "algorand": "assets/logos/ALGO.svg",
    "usdtalgo": "assets/logos/USDT.svg",
    "usdcalgo": "assets/logos/USDC.svg",
    "planetsalgo": "assets/logos/PLANETS.svg",
    "xetalgo": "assets/logos/XET.svg",
    "opulalgo": "assets/logos/OPUL.svg",
    "stblalgo": "assets/logos/STBL.svg",
    "fluxalgo": "assets/logos/FLUX.svg",
    "kaspa": "assets/logos/KAS.svg",
    "fluxmatic": "assets/logos/FLUX.svg",
    "zusdtestkda": "assets/logos/USDC.svg",
    "zusdkda": "assets/logos/ZUSD.svg",
    "developmentkadena": "assets/logos/TESTKDA.svg",
    "base": "assets/logos/BASE.svg",
    "basesepolia": "assets/logos/BASE.svg",
    "usdcbase": "assets/logos/USDC.svg",
    "daibase": "assets/logos/SAI.svg",
    "fluxbase": "assets/logos/FLUX.svg",
    "clore": "assets/logos/CLORE.svg",
  };
}
