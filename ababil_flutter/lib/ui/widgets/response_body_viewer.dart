import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syntax_highlight/syntax_highlight.dart';

class ResponseBodyViewer extends StatefulWidget {
  final String body;
  final Map<String, String>? headers;

  const ResponseBodyViewer({super.key, required this.body, this.headers});

  @override
  State<ResponseBodyViewer> createState() => _ResponseBodyViewerState();
}

class _ResponseBodyViewerState extends State<ResponseBodyViewer> {
  String _selectedLanguage = 'json';
  String _formattedBody = '';
  bool _isFormatted = false;

  @override
  void initState() {
    super.initState();
    // Detect language synchronously first
    _detectLanguageSync();
    _formatBody();
  }

  @override
  void didUpdateWidget(ResponseBodyViewer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.body != widget.body) {
      _detectLanguage();
      _formatBody();
    }
  }

  Future<Highlighter> _createHighlighter(
    String language,
    BuildContext context,
  ) async {
    await Highlighter.initialize(['json', 'html']);
    // Use the detected language (fallback to json if plaintext)
    final lang = language == 'plaintext' ? 'json' : language.toLowerCase();
    return Highlighter(
      language: lang,
      theme: await HighlighterTheme.loadDarkTheme(),
    );
  }

  String _detectLanguageSync() {
    if (widget.body.trim().isEmpty) {
      _selectedLanguage = 'plaintext';
      return 'plaintext';
    }

    // Check Content-Type header first
    final contentType = widget.headers?['content-type']?.toLowerCase() ?? '';
    if (contentType.contains('application/json')) {
      _selectedLanguage = 'json';
      return 'json';
    }
    if (contentType.contains('application/xml') ||
        contentType.contains('text/xml')) {
      _selectedLanguage = 'xml';
      return 'xml';
    }
    if (contentType.contains('text/html')) {
      _selectedLanguage = 'html';
      return 'html';
    }
    if (contentType.contains('text/css')) {
      _selectedLanguage = 'css';
      return 'css';
    }
    if (contentType.contains('text/javascript') ||
        contentType.contains('application/javascript')) {
      _selectedLanguage = 'javascript';
      return 'javascript';
    }
    if (contentType.contains('application/x-yaml') ||
        contentType.contains('text/yaml')) {
      _selectedLanguage = 'yaml';
      return 'yaml';
    }

    // Auto-detect from content
    final trimmed = widget.body.trim();
    if (trimmed.startsWith('{') || trimmed.startsWith('[')) {
      try {
        jsonDecode(widget.body);
        _selectedLanguage = 'json';
        return 'json';
      } catch (_) {
        _selectedLanguage = 'plaintext';
        return 'plaintext';
      }
    }
    if (trimmed.startsWith('<')) {
      if (trimmed.contains('<!DOCTYPE') || trimmed.contains('<html')) {
        _selectedLanguage = 'html';
        return 'html';
      }
      _selectedLanguage = 'xml';
      return 'xml';
    }

    _selectedLanguage = 'plaintext';
    return 'plaintext';
  }

  void _detectLanguage() {
    final newLanguage = _detectLanguageSync();
    if (_selectedLanguage != newLanguage) {
      setState(() {
        _selectedLanguage = newLanguage;
      });
    }
  }

  void _formatBody() {
    if (_selectedLanguage == 'json') {
      try {
        final decoded = jsonDecode(widget.body);
        setState(() {
          _formattedBody = const JsonEncoder.withIndent('  ').convert(decoded);
          _isFormatted = true;
        });
        return;
      } catch (_) {
        setState(() {
          _formattedBody = widget.body;
          _isFormatted = false;
        });
        return;
      }
    }
    setState(() {
      _formattedBody = widget.body;
      _isFormatted = false;
    });
  }

  void _formatCode() {
    if (_selectedLanguage == 'json' && !_isFormatted) {
      _formatBody();
    }
  }

  void _copyToClipboard() {
    final text = _formattedBody.isEmpty ? widget.body : _formattedBody;
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Copied to clipboard'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _onLanguageChanged(String? newLanguage) {
    if (newLanguage != null) {
      setState(() {
        _selectedLanguage = newLanguage;
      });
      _formatBody();
    }
  }

  @override
  Widget build(BuildContext context) {
    final displayText = _formattedBody.isEmpty ? widget.body : _formattedBody;

    return Column(
      children: [
        // Toolbar
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            border: Border(
              bottom: BorderSide(
                color: Theme.of(context).brightness == Brightness.dark
                    ? const Color(0xFF3D3D3D)
                    : Colors.grey.shade300,
              ),
            ),
          ),
          child: Row(
            children: [
              // Left side - Format selector
              DropdownButton<String>(
                value: _selectedLanguage,
                underline: Container(),
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).textTheme.bodySmall?.color,
                ),
                items: const [
                  DropdownMenuItem(value: 'json', child: Text('{} JSON')),
                  DropdownMenuItem(value: 'xml', child: Text('XML')),
                  DropdownMenuItem(value: 'html', child: Text('HTML')),
                  DropdownMenuItem(
                    value: 'javascript',
                    child: Text('JavaScript'),
                  ),
                  DropdownMenuItem(value: 'css', child: Text('CSS')),
                  DropdownMenuItem(value: 'yaml', child: Text('YAML')),
                  DropdownMenuItem(value: 'plaintext', child: Text('Text')),
                ],
                onChanged: _onLanguageChanged,
              ),
              const SizedBox(width: 8),
              // Format button
              if (_selectedLanguage == 'json' && !_isFormatted)
                IconButton(
                  icon: const Icon(Icons.format_align_left, size: 18),
                  onPressed: _formatCode,
                  tooltip: 'Format JSON',
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  color: Theme.of(context).textTheme.bodySmall?.color,
                ),
              const Spacer(),
              // Right side - Actions
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.copy, size: 18),
                    onPressed: _copyToClipboard,
                    tooltip: 'Copy',
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    color: Theme.of(context).textTheme.bodySmall?.color,
                  ),
                ],
              ),
            ],
          ),
        ),
        // Body content
        Expanded(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            color: Theme.of(context).cardTheme.color,
            child: widget.body.isEmpty
                ? Center(
                    child: Text(
                      '(empty)',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  )
                : SingleChildScrollView(
                    child: SelectableRegion(
                      focusNode: FocusNode(),
                      selectionControls: MaterialTextSelectionControls(),
                      child: _selectedLanguage == 'plaintext'
                          ? Text(
                              displayText,
                              style: const TextStyle(
                                fontFamily: 'monospace',
                                fontSize: 13,
                                height: 1.5,
                              ),
                            )
                          : FutureBuilder<Highlighter>(
                              key: ValueKey(_selectedLanguage),
                              future: _createHighlighter(
                                _selectedLanguage,
                                context,
                              ),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Text(
                                    displayText,
                                    style: const TextStyle(
                                      fontFamily: 'monospace',
                                      fontSize: 13,
                                      height: 1.5,
                                    ),
                                  );
                                }

                                if (snapshot.hasError) {
                                  debugPrint(
                                    'Highlighter error: ${snapshot.error}',
                                  );
                                  return Text(
                                    displayText,
                                    style: const TextStyle(
                                      fontFamily: 'monospace',
                                      fontSize: 13,
                                      height: 1.5,
                                    ),
                                  );
                                }

                                if (snapshot.hasData) {
                                  return Text.rich(
                                    snapshot.data!.highlight(displayText),
                                    style: const TextStyle(
                                      fontFamily: 'monospace',
                                      fontSize: 13,
                                      height: 1.5,
                                    ),
                                  );
                                }

                                return Text(
                                  displayText,
                                  style: const TextStyle(
                                    fontFamily: 'monospace',
                                    fontSize: 13,
                                    height: 1.5,
                                  ),
                                );
                              },
                            ),
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}
