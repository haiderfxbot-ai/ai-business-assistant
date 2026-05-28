import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../models/ai_settings_model.dart';

class AISettingsScreen extends StatefulWidget {
  const AISettingsScreen({super.key});

  @override
  State<AISettingsScreen> createState() => _AISettingsScreenState();
}

class _AISettingsScreenState extends State<AISettingsScreen> {
  AIMode _primaryMode = AIMode.local;
  AIMode _secondaryMode = AIMode.cloud;
  String _aiTone = 'Professional';
  bool _enableAutoReply = true;
  bool _enableUrdu = true;
  final _templates = <ReplyTemplate>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AI Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('AI Decision System', style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: 16),
                  const Text('Primary AI Mode', style: TextStyle(fontWeight: FontWeight.w500)),
                  SegmentedButton<AIMode>(
                    segments: const [
                      ButtonSegment(value: AIMode.template, label: Text('Template')),
                      ButtonSegment(value: AIMode.local, label: Text('Local AI')),
                      ButtonSegment(value: AIMode.cloud, label: Text('Cloud AI')),
                    ],
                    selected: {_primaryMode},
                    onSelectionChanged: (v) => setState(() => _primaryMode = v.first),
                  ),
                  const SizedBox(height: 16),
                  const Text('Secondary AI Mode (fallback)', style: TextStyle(fontWeight: FontWeight.w500)),
                  SegmentedButton<AIMode>(
                    segments: const [
                      ButtonSegment(value: AIMode.template, label: Text('Template')),
                      ButtonSegment(value: AIMode.local, label: Text('Local AI')),
                      ButtonSegment(value: AIMode.cloud, label: Text('Cloud AI')),
                    ],
                    selected: {_secondaryMode},
                    onSelectionChanged: (v) => setState(() => _secondaryMode = v.first),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('AI Tone', style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: _aiTone,
                    items: ['Professional', 'Friendly', 'Formal', 'Casual']
                      .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                      .toList(),
                    onChanged: (v) => setState(() => _aiTone = v!),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Enable Auto Reply'),
                  subtitle: const Text('AI automatically replies to messages'),
                  value: _enableAutoReply,
                  onChanged: (v) => setState(() => _enableAutoReply = v),
                ),
                const Divider(height: 1),
                SwitchListTile(
                  title: const Text('Urdu Support'),
                  subtitle: const Text('Reply in Urdu/Roman Urdu'),
                  value: _enableUrdu,
                  onChanged: (v) => setState(() => _enableUrdu = v),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Reply Templates', style: Theme.of(context).textTheme.headlineMedium),
                      IconButton(
                        icon: const Icon(Icons.add_circle, color: AppTheme.secondaryColor),
                        onPressed: () => _addTemplate(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (_templates.isEmpty)
                    Text('No templates added yet', style: TextStyle(color: Colors.grey[600]))
                  else
                    ..._templates.map((t) => ListTile(
                      title: Text(t.triggerKeyword),
                      subtitle: Text(t.replyText, maxLines: 1, overflow: TextOverflow.ellipsis),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => setState(() => _templates.remove(t)),
                      ),
                    )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _addTemplate(BuildContext context) {
    final keywordCtrl = TextEditingController();
    final replyCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Template'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: keywordCtrl, decoration: const InputDecoration(labelText: 'Trigger Keyword'), autofocus: true),
            const SizedBox(height: 12),
            TextField(controller: replyCtrl, decoration: const InputDecoration(labelText: 'Reply Text'), maxLines: 3),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(onPressed: () {
            if (keywordCtrl.text.isNotEmpty && replyCtrl.text.isNotEmpty) {
              setState(() => _templates.add(ReplyTemplate(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                triggerKeyword: keywordCtrl.text,
                replyText: replyCtrl.text,
              )));
              Navigator.pop(ctx);
            }
          }, child: const Text('Add')),
        ],
      ),
    );
  }
}
