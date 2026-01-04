import 'package:flutter/material.dart';

class ParamsPanel extends StatelessWidget {
  final List<MapEntry<String, String>> params;
  final VoidCallback onAddParam;
  final ValueChanged<String> onRemoveParam;
  final ValueChanged<MapEntry<String, String>> onParamChanged;

  const ParamsPanel({
    super.key,
    required this.params,
    required this.onAddParam,
    required this.onRemoveParam,
    required this.onParamChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Query Params',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              Row(
                children: [
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Cookies',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Bulk Edit',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        // Table header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: Theme.of(context).cardTheme.color,
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
              Expanded(
                flex: 2,
                child: Text(
                  'Key',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).textTheme.bodySmall?.color,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  'Value',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).textTheme.bodySmall?.color,
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  'Description',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).textTheme.bodySmall?.color,
                  ),
                ),
              ),
              const SizedBox(width: 40),
            ],
          ),
        ),
        // Params list
        Expanded(
          child: params.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.table_chart_outlined,
                        size: 48,
                        color: Theme.of(context).textTheme.bodySmall?.color,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No params',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: 8),
                      TextButton.icon(
                        onPressed: onAddParam,
                        icon: const Icon(Icons.add, size: 18),
                        label: const Text('Add Param'),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: params.length + 1,
                  itemBuilder: (context, index) {
                    if (index == params.length) {
                      return Padding(
                        padding: const EdgeInsets.all(10),
                        child: TextButton.icon(
                          onPressed: onAddParam,
                          icon: const Icon(Icons.add, size: 18),
                          label: const Text('Add Param'),
                          style: TextButton.styleFrom(
                            foregroundColor: Theme.of(
                              context,
                            ).colorScheme.primary,
                          ),
                        ),
                      );
                    }
                    final param = params[index];
                    return _ParamRow(
                      key: ValueKey('${param.key}_$index'),
                      param: param,
                      onRemove: () => onRemoveParam(param.key),
                      onChanged: (newParam) => onParamChanged(newParam),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class _ParamRow extends StatefulWidget {
  final MapEntry<String, String> param;
  final VoidCallback onRemove;
  final ValueChanged<MapEntry<String, String>> onChanged;

  const _ParamRow({
    super.key,
    required this.param,
    required this.onRemove,
    required this.onChanged,
  });

  @override
  State<_ParamRow> createState() => _ParamRowState();
}

class _ParamRowState extends State<_ParamRow> {
  late TextEditingController _keyController;
  late TextEditingController _valueController;
  late TextEditingController _descController;

  @override
  void initState() {
    super.initState();
    _keyController = TextEditingController(text: widget.param.key);
    _valueController = TextEditingController(text: widget.param.value);
    _descController = TextEditingController();
  }

  @override
  void dispose() {
    _keyController.dispose();
    _valueController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _notifyChange() {
    widget.onChanged(MapEntry(_keyController.text, _valueController.text));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).brightness == Brightness.dark
                ? const Color(0xFF3D3D3D)
                : Colors.grey.shade300,
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: TextField(
              controller: _keyController,
              style: const TextStyle(fontSize: 13),
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Key',
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
              ),
              onChanged: (_) => _notifyChange(),
            ),
          ),
          Expanded(
            flex: 2,
            child: TextField(
              controller: _valueController,
              style: const TextStyle(fontSize: 13),
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Value',
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
              ),
              onChanged: (_) => _notifyChange(),
            ),
          ),
          Expanded(
            flex: 1,
            child: TextField(
              controller: _descController,
              style: const TextStyle(fontSize: 13),
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Description',
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, size: 16),
            onPressed: widget.onRemove,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }
}
