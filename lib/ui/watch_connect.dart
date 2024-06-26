import 'dart:async';

import 'package:flutter/material.dart';

import 'package:watch_connectivity/watch_connectivity.dart';

late final bool isWear;

class MyAndroidApp extends StatefulWidget {
  const MyAndroidApp({Key? key}) : super(key: key);

  @override
  State<MyAndroidApp> createState() => _MyAndroidAppState();
}

class _MyAndroidAppState extends State<MyAndroidApp> {
  final _watch = WatchConnectivity();

  var _count = 0;

  var _supported = false;
  var _paired = false;
  var _reachable = false;
  var _context = <String, dynamic>{};
  var _receivedContexts = <Map<String, dynamic>>[];
  final _log = <String>[];
  final isWear = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();

    _watch.messageStream
        .listen((e) => setState(() => _log.add('Received message: $e')));

    _watch.contextStream
        .listen((e) => setState(() => _log.add('Received context: $e')));

    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  void initPlatformState() async {
    _supported = await _watch.isSupported;
    _paired = await _watch.isPaired;
    _reachable = await _watch.isReachable;
    _context = await _watch.applicationContext;
    _receivedContexts = await _watch.receivedApplicationContexts;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final home = Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Supported: $_supported'),
                Text('Paired: $_paired'),
                Text('Reachable: $_reachable'),
                Text('Context: $_context'),
                Text('Received contexts: $_receivedContexts'),
                TextButton(
                  onPressed: initPlatformState,
                  child: const Text('Refresh'),
                ),
                const SizedBox(height: 8),
                const Text('Send'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: sendMessage,
                      child: const Text('Message'),
                    ),
                    const SizedBox(width: 8),
                    TextButton(
                      onPressed: sendContext,
                      child: const Text('Context'),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: toggleBackgroundMessaging,
                  child: Text(
                    '${timer == null ? 'Start' : 'Stop'} background messaging',
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(width: 16),
                TextButton(
                  onPressed: startWatchApp,
                  child: const Text('Start watch app'),
                ),
                const SizedBox(width: 16),
                const Text('Log'),
                ..._log.reversed.map(Text.new),
              ],
            ),
          ),
        ),
      ),
    );

    return MaterialApp(
      home: home,
    );
  }

  void startWatchApp() {}

  void sendMessage() {
    final message = {'data': 'start'};
    _watch.sendMessage(message);
    setState(() => _log.add('Sent message: $message'));
  }

  void sendContext() {
    _count++;
    final context = {'data': 'stop'};
    //_watch.updateApplicationContext(context);

    _watch.sendMessage(context);
    setState(() => _log.add('Sent message: $context'));
  }

  void toggleBackgroundMessaging() {
    if (timer == null) {
      timer = Timer.periodic(const Duration(seconds: 1), (_) {
        final message = {'data': 'phone'};
        _watch.sendMessage(message);
        setState(() => _log.add('Sent message: $message'));
      });
    } else {
      timer?.cancel();
      timer = null;
    }
    setState(() {});
  }
}
