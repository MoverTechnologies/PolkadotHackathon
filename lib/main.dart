import 'package:mover/app/common/endpoint/amplify_endpoint.dart';
import 'package:mover/app/common/utils/remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mover/landing_view.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:provider/provider.dart';

// providers
import 'app/common/providers/menu_provider.dart';
import 'app/common/providers/theme_provider.dart';
import 'app/common/providers/user_provider.dart';
import 'app/common/providers/wallet_provider.dart';
import 'app/common/utils/notification.dart';
import 'app/pages/mod_order/providers/mod_search_provider.dart';
import 'app/pages/task_status/providers/task_status_provider.dart';

void main() async {
  await Hive.initFlutter();
  WidgetsFlutterBinding.ensureInitialized();

  // firebase init
  Notifications _notifi = Notifications();
  await _notifi.init();

  await RemoteConfigService.fetchRemoteConfig();

  final ModSearchProvider _modSearchProvider = ModSearchProvider();
  await _modSearchProvider.init();

  AmplifyEndpoint _amplifyEndpoint = AmplifyEndpoint();
  await _amplifyEndpoint.init();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MultiProvider(providers: [
      ChangeNotifierProvider(create: (context) => MenuProvider()),
      ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ChangeNotifierProvider(create: (context) => WalletProvider()),
      ChangeNotifierProvider(create: (context) => UserProvider()),
      ChangeNotifierProvider(create: (context) => _modSearchProvider),
      ChangeNotifierProvider(create: (context) => TaskStatusProvider()),
    ], child: const MyApp()));
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mover',
      theme: context.select((ThemeProvider _model) => _model.theme),
      debugShowCheckedModeBanner: false,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: SafeArea(child: LandingView()),
    );
  }
}
