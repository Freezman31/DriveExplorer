import 'package:drive_explorer/api/drive.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:syncfusion_flutter_charts/charts.dart';

class InfoCard extends StatefulWidget {
  final List<Item> driveItems;
  const InfoCard({super.key, required this.driveItems});

  @override
  State<InfoCard> createState() => _InfoCardState();
}

class _InfoCardState extends State<InfoCard> {
  String actualPath = '/';
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final source = widget.driveItems
        .where((element) => p.dirname(element.path) == actualPath)
        .toList();
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(32),
      ),
      child: Column(
        children: [
          Expanded(
            child: InkWell(
              child: const Icon(Icons.arrow_back),
              onTap: () {
                setState(() {
                  actualPath = p.dirname(actualPath);
                });
              },
            ),
          ),
          Expanded(
            flex: 15,
            child: SfCircularChart(
              onSelectionChanged: (SelectionArgs args) {
                final item = source[args.pointIndex];
                if (item.type == ItemType.file) return;
                setState(() {
                  actualPath = item.path;
                });
              },
              series: [
                DoughnutSeries<Item, String>(
                    dataSource: source,
                    xValueMapper: (Item data, _) => data.id,
                    yValueMapper: (Item data, _) => data.size,
                    dataLabelMapper: (Item data, _) => widget.driveItems
                        .firstWhere((element) => element.id == data.id)
                        .name,
                    dataLabelSettings: const DataLabelSettings(
                      isVisible: true,
                      useSeriesColor: true,
                      labelPosition: ChartDataLabelPosition.outside,
                    ),
                    selectionBehavior: SelectionBehavior(enable: true)),
              ],
            ),
          )
        ],
      ),
    );
  }
}
