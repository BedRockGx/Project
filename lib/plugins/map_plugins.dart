import 'package:flutter/material.dart';

/*
   地图封装控件
 */
class DiscreteSetting extends StatelessWidget {
  const DiscreteSetting({
    Key key,
    @required this.head,
    @required this.options,
    @required this.onSelected,
  }) : super(key: key);

  final String head;
  final List<String> options;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: onSelected,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(head, style: Theme.of(context).textTheme.subhead),
      ),
      itemBuilder: (context) {
        return options
            .map((value) => PopupMenuItem<String>(
                  child: Text(value),
                  value: value,
                ))
            .toList();
      },
    );
  }
}