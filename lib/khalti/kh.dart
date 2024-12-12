import 'package:flutter/material.dart';
import 'package:payment_gateway_package/khalti/khalti_viewmodel.dart';
import 'package:provider/provider.dart';

class KhaltiWidget extends StatelessWidget {
  const KhaltiWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<KhaltiViewmodel>(
        create: (_) => KhaltiViewmodel()..initializeKhalti(),
        child: Consumer<KhaltiViewmodel>(
          builder: (context, khaltiViewmodel, child) {
            if (khaltiViewmodel.pop) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.pop(context);
              });
            }

            return Center(
                child: FutureBuilder(
                    future: khaltiViewmodel.khalti,
                    initialData: null,
                    builder: (context, snapshot) {
                      final khaltiSnapshot = snapshot.data;
                      if (khaltiSnapshot == null) {
                        return const CircularProgressIndicator.adaptive();
                      }
                      return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            OutlinedButton(
                              onPressed: () => khaltiSnapshot.open(context),
                              child: const Text('Pay with Khalti'),
                            ),
                          ]);
                    }));
          },
        ));
  }
}
