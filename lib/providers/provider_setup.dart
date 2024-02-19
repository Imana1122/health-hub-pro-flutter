import 'package:fyp_flutter/providers/dietician_auth_provider.dart';
import 'package:fyp_flutter/providers/locator.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'auth_provider.dart';
import 'conversation_provider.dart';

List<SingleChildWidget> providers = [
  ChangeNotifierProvider(
    create: (context) => locator<ConversationProvider>(),
  ),
  ChangeNotifierProvider(
    create: (context) => locator<AuthProvider>(),
  ),
  ChangeNotifierProvider(
    create: (context) => locator<DieticianAuthProvider>(),
  ),
];
