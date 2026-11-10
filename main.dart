import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => VpnProvider()),
      ],
      child: const VPNSOPRWGApp(),
    ),
  );
}

class VPNSOPRWGApp extends StatelessWidget {
  const VPNSOPRWGApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VPNSOPRWG',
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.blueAccent,
        scaffoldBackgroundColor: const Color(0xFF121212),
      ),
      home: const LoginScreen(),
    );
  }
}

class VpnProvider extends ChangeNotifier {
  bool _isConnected = false;
  String _selectedMode = 'Web'; 
  double _remainingDataGB = 12.5; 

  bool get isConnected => _isConnected;
  String get selectedMode => _selectedMode;
  double get remainingDataGB => _remainingDataGB;

  void toggleConnection() {
    _isConnected = !_isConnected;
    notifyListeners();
  }

  void setMode(String mode) {
    if (!_isConnected) {
      _selectedMode = mode;
      notifyListeners();
    }
  }
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('VPNSOPRWG', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.blueAccent)),
              const SizedBox(height: 40),
              TextField(decoration: InputDecoration(labelText: 'شماره موبایل یا ایمیل', border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)))),
              const SizedBox(height: 20),
              TextField(obscureText: true, decoration: InputDecoration(labelText: 'رمز عبور', border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)))),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const DashboardScreen()));
                  },
                  child: const Text('ورود / احراز هویت', style: TextStyle(fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final vpnProvider = Provider.of<VpnProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('VPNSOPRWG'), centerTitle: true, elevation: 0, backgroundColor: Colors.transparent),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: Colors.grey[900], borderRadius: BorderRadius.circular(15)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('حجم باقی‌مانده:', style: TextStyle(fontSize: 18)),
                Text('${vpnProvider.remainingDataGB} GB', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.greenAccent)),
              ],
            ),
          ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ChoiceChip(label: const Text('🌐 وب‌گردی (Xray)'), selected: vpnProvider.selectedMode == 'Web', onSelected: (bool selected) { if (selected) vpnProvider.setMode('Web'); }),
              const SizedBox(width: 20),
              ChoiceChip(label: const Text('🎮 گیمینگ (Wireguard)'), selected: vpnProvider.selectedMode == 'Gaming', onSelected: (bool selected) { if (selected) vpnProvider.setMode('Gaming'); }),
            ],
          ),
          const Spacer(),
          GestureDetector(
            onTap: vpnProvider.toggleConnection,
            child: Container(
              width: 180, height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: vpnProvider.isConnected ? Colors.green.withOpacity(0.2) : Colors.red.withOpacity(0.2),
                border: Border.all(color: vpnProvider.isConnected ? Colors.green : Colors.red, width: 4),
              ),
              child: Center(child: Icon(Icons.power_settings_new, size: 80, color: vpnProvider.isConnected ? Colors.greenAccent : Colors.redAccent)),
            ),
          ),
          const SizedBox(height: 20),
          Text(vpnProvider.isConnected ? 'متصل به سرور ${vpnProvider.selectedMode}' : 'قطع است', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(onPressed: () {}, icon: const Icon(Icons.payment), label: const Text('شارژ حساب')),
                ElevatedButton.icon(onPressed: () {}, icon: const Icon(Icons.support_agent), label: const Text('پشتیبانی')),
              ],
            ),
          )
        ],
      ),
    );
  }
}
