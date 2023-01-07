import 'package:backup_tool/api/drive.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class InfoCard extends StatelessWidget {
  final List<Item> driveItems;
  const InfoCard({super.key, required this.driveItems});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(32),
      ),
      child: Row(
        children: [
          Expanded(
            child: SfCircularChart(
              series: [
                DoughnutSeries<ItemData, String>(
                  dataSource: driveItems
                      .where((element) => element.type == ItemType.folder)
                      .map((e) => ItemData.fromItem(e))
                      .toList(),
                  xValueMapper: (ItemData data, _) => data.id,
                  yValueMapper: (ItemData data, _) => data.size,
                  dataLabelMapper: (ItemData data, _) => driveItems
                      .firstWhere((element) => element.id == data.id)
                      .name,
                  dataLabelSettings: const DataLabelSettings(
                    isVisible: true,
                    useSeriesColor: true,
                    labelPosition: ChartDataLabelPosition.outside,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
