import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluxswap/ui/fluxexchangepage/fluxexchangescreen.dart';
import 'package:fluxswap/ui/web3/walletdrawer.dart';
import 'package:fluxswap/ui/web3/networkselectionmenu.dart';
import 'package:fluxswap/providers/flux_swap_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:clipboard/clipboard.dart';

void main() {
  runApp(const CryptoSwapApp());
}

class CryptoSwapApp extends StatelessWidget {
  const CryptoSwapApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Crypto Swap Demo',
      theme: ThemeData.light(),
      home: const CryptoSwapPage(),
    );
  }
}

class CryptoSwapPage extends StatefulWidget {
  const CryptoSwapPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CryptoSwapPageState createState() => _CryptoSwapPageState();
}

class _CryptoSwapPageState extends State<CryptoSwapPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController toAmountController = TextEditingController(text: "0");

  TextEditingController transactionIDController =
      TextEditingController(text: "");

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => FluxSwapProvider()..init(),
      builder: (context, child) {
        return Scaffold(
            // backgroundColor: const Color(0xFF1b202b),
            key: _scaffoldKey,
            endDrawer: const WalletDrawer(),
            body:
                Consumer<FluxSwapProvider>(builder: (context, provider, child) {
              // Listen for errors and show them as they appear
              if (provider.errors.isNotEmpty) {
                Future.microtask(
                    () => _showErrorSnackbar(context, provider.errors.last));
              }

              return Stack(
                alignment: Alignment.topLeft,
                children: [
                  Positioned(
                    top: 0,
                    left: 0,
                    child: SvgPicture.asset(
                      '/images/flux-icon.svg',
                      width: 80,
                      height: 80,
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: NetworkSelectionMenu(
                      scaffoldKey: _scaffoldKey,
                    ),
                  ),
                  const Positioned.fill(
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: 80), // Adjust padding to avoid overlap
                      child: FluxExchangeScreen(),
                    ),
                  ),
                ],
              );
            }));
      },
    );
  }

  void _showSnackbar() {
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Text Copied")));
  }

  void _showErrorSnackbar(BuildContext context, String error) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(error),
      duration: const Duration(seconds: 2),
      backgroundColor: Colors.red,
    ));
  }

  void _copytext(String copytext) {
    FlutterClipboard.copy(copytext).then((value) => _showSnackbar());
  }
}
