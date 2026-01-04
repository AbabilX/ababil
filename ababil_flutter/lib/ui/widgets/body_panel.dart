import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:ababil_flutter/ui/widgets/custom_code_editor.dart';

class BodyPanel extends StatefulWidget {
  final TextEditingController controller;
  final String? hintText;

  const BodyPanel({super.key, required this.controller, this.hintText});

  @override
  State<BodyPanel> createState() => _BodyPanelState();
}

class _BodyPanelState extends State<BodyPanel> {
  String _selectedLanguage = 'json';

  @override
  void initState() {
    super.initState();
    _detectLanguage(widget.controller.text);
    widget.controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onTextChanged() {
    _detectLanguage(widget.controller.text);
  }

  void _detectLanguage(String text) {
    if (text.trim().isEmpty) {
      setState(() => _selectedLanguage = 'json');
      return;
    }

    final trimmed = text.trim();
    if (trimmed.startsWith('{') || trimmed.startsWith('[')) {
      try {
        jsonDecode(text);
        setState(() => _selectedLanguage = 'json');
        return;
      } catch (_) {}
    }

    if (trimmed.startsWith('<')) {
      if (trimmed.contains('<!DOCTYPE') || trimmed.contains('<html')) {
        setState(() => _selectedLanguage = 'html');
        return;
      }
      setState(() => _selectedLanguage = 'xml');
      return;
    }

    setState(() => _selectedLanguage = 'json');
  }

  String _formatJson(String text) {
    try {
      final decoded = jsonDecode(text);
      return const JsonEncoder.withIndent('  ').convert(decoded);
    } catch (_) {
      return text;
    }
  }

  void _formatCode() {
    if (_selectedLanguage == 'json') {
      final formatted = _formatJson(widget.controller.text);
      if (formatted != widget.controller.text) {
        widget.controller.text = formatted;
        widget.controller.selection = TextSelection.collapsed(
          offset: formatted.length,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Body', style: Theme.of(context).textTheme.titleMedium),
              const Spacer(),
              // Language selector
              DropdownButton<String>(
                value: _selectedLanguage,
                underline: Container(),
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).textTheme.bodySmall?.color,
                ),
                items: const [
                  DropdownMenuItem(value: 'json', child: Text('JSON')),
                  DropdownMenuItem(value: 'xml', child: Text('XML')),
                  DropdownMenuItem(value: 'html', child: Text('HTML')),
                  DropdownMenuItem(
                    value: 'javascript',
                    child: Text('JavaScript'),
                  ),
                  DropdownMenuItem(value: 'css', child: Text('CSS')),
                  DropdownMenuItem(value: 'yaml', child: Text('YAML')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _selectedLanguage = value);
                  }
                },
              ),
              const SizedBox(width: 8),
              // Format button
              if (_selectedLanguage == 'json')
                IconButton(
                  icon: const Icon(Icons.format_align_left, size: 18),
                  onPressed: _formatCode,
                  tooltip: 'Format JSON',
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  color: Theme.of(context).textTheme.bodySmall?.color,
                ),
            ],
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardTheme.color,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? const Color(0xFF3D3D3D)
                      : Colors.grey.shade300,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: CustomCodeEditor(
                  controller: widget.controller,
                  hintText: widget.hintText,
                  language: _selectedLanguage,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
