import 'package:flutter/material.dart';

import 'app_settings_controller.dart';
import 'language/app_text.dart';

// A simple page providing basic music theory information relevant to using the metronome app
class MusicBasicsPage extends StatelessWidget {
  const MusicBasicsPage({super.key, required this.appSettingsController});

  final AppSettingsController appSettingsController;

  @override
  Widget build(BuildContext context) {
    final text = appTextFor(appSettingsController.language);
    final scheme = Theme.of(context).colorScheme;
    final cards = [
      (text.bpmBasicsTitle, text.bpmBasicsBody),
      (text.timeSignatureBasicsTitle, text.timeSignatureBasicsBody),
      (text.subdivisionBasicsTitle, text.subdivisionBasicsBody),
      (text.downbeatBasicsTitle, text.downbeatBasicsBody),
      (text.jianpuBasicsTitle, text.jianpuBasicsBody),
    ];

    return Scaffold(
      appBar: AppBar(title: Text(text.musicBasics)),
      body: ListView.separated(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        itemCount: cards.length + 1,
        separatorBuilder: (_, _) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          if (index == 0) {
            return Text(
              text.basicsIntro,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
            );
          }

          final card = cards[index - 1];
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
            decoration: BoxDecoration(
              color: scheme.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: scheme.outlineVariant),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  card.$1,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 6),
                Text(
                  card.$2,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
