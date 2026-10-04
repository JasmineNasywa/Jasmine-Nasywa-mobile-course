import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../app/router.dart';
import '../core/secure_store.dart';
import '../services/device_api.dart';
import '../services/push_service.dart';

final secureStoreProvider = Provider((_) => const SecureStore());

final deviceApiProvider =
    Provider((ref) => DeviceApi(ref.watch(secureStoreProvider)));

final pushServiceProvider = Provider<PushService>((ref) {
  final svc = PushService(
    router: ref.watch(routerProvider),
    api: ref.watch(deviceApiProvider),
    store: ref.watch(secureStoreProvider),
  );
  ref.onDispose(svc.dispose);
  return svc;
});

/// Status langganan topic pengumuman-kampus.
class SubscriptionNotifier extends AsyncNotifier<bool> {
  @override
  Future<bool> build() => ref.read(secureStoreProvider).readSubscribed();

  Future<void> set(bool value) async {
    final push = ref.read(pushServiceProvider);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      value
          ? await push.subscribeAnnouncements()
          : await push.unsubscribeAnnouncements();
      return value;
    });
  }
}

final subscriptionProvider =
    AsyncNotifierProvider<SubscriptionNotifier, bool>(SubscriptionNotifier.new);
