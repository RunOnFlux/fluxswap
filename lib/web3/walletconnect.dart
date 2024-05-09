import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:walletconnect_flutter_v2/walletconnect_flutter_v2.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WalletConnect v2 Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: WalletConnectScreen(),
    );
  }
}

class WalletConnectScreen extends StatefulWidget {
  @override
  _WalletConnectScreenState createState() => _WalletConnectScreenState();
}

class _WalletConnectScreenState extends State<WalletConnectScreen> {
  late Web3App wcClient;
  String? uri;
  SessionData? session;
  bool _isConnected = false;
  String _qrData = '';

  @override
  void initState() {
    super.initState();
    initWalletConnect();
  }

  Future<void> initWalletConnect() async {
    wcClient = await Web3App.createInstance(
      relayUrl: 'wss://relay.walletconnect.com',
      projectId: '9c5124b5c7a498fb581a197bbb19d6ec',
      metadata: const PairingMetadata(
        name: 'Flutter dApp',
        description: 'A Flutter dApp to sign messages',
        url: 'https://walletconnect.com',
        icons: ['https://avatars.githubusercontent.com/u/37784886'],
      ),
    );

    final resp = await wcClient.connect(
      requiredNamespaces: {
        'eip155': const RequiredNamespace(
          chains: ['eip155:1'],
          methods: [
            'personal_sign',
          ],
          events: [],
        ),
      },
      optionalNamespaces: {
        'eip155': const RequiredNamespace(
          chains: ['eip155:1'],
          methods: ['eth_signTransaction'],
          events: [],
        ),
      },
    );

    setState(() {
      uri = resp.uri?.toString();
      _qrData = uri!;
      print(_qrData);
    });

    // Await session data
    session = await resp.session.future;

    setState(() {
      _isConnected = true;
      _qrData = '';
    });
  }

  Future<void> signMessage() async {
    if (session == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No active session')),
      );
      return;
    }

    final String connectedAddress =
        session!.namespaces['eip155']!.accounts[0].split(":")[2];
    final String message = "Hello, WalletConnect!";

    try {
      final signResponse = await wcClient.request(
        topic: session!.topic,
        chainId: 'eip155:1',
        request: SessionRequestParams(
          method: 'personal_sign',
          params: [
            message,
            connectedAddress,
          ],
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Signed Message: $signResponse')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('WalletConnect v2 Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!_isConnected && _qrData.isNotEmpty)
              QrImageView(
                data: _qrData,
                size: 200,
              ),
            if (_isConnected)
              Text(
                'Connected!',
                style: TextStyle(fontSize: 24, color: Colors.green),
              ),
            if (_isConnected)
              ElevatedButton(
                onPressed: signMessage,
                child: Text('Sign Message'),
              ),
          ],
        ),
      ),
    );
  }
}
