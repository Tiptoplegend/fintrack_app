class BarData {
  final double sunAmount,
      monAmount,
      tueAmount,
      wedAmount,
      thuAmount,
      friAmount,
      satAmount;
  final String filter;
  List<BarDataItem> barData = [];

  BarData({
    required this.sunAmount,
    required this.monAmount,
    required this.tueAmount,
    required this.wedAmount,
    required this.thuAmount,
    required this.friAmount,
    required this.satAmount,
    required this.filter,
  });

  void initializedBarData() {
    barData = [
      BarDataItem(x: 0, y: sunAmount),
      BarDataItem(x: 1, y: monAmount),
      BarDataItem(x: 2, y: tueAmount),
      BarDataItem(x: 3, y: wedAmount),
      BarDataItem(x: 4, y: thuAmount),
    ];
    if (filter == 'Monthly') {
      barData.add(BarDataItem(x: 5, y: friAmount));
    } else if (filter == 'Weekly') {
      barData.addAll([
        BarDataItem(x: 5, y: friAmount),
        BarDataItem(x: 6, y: satAmount),
      ]);
    }
    // For 'Yearly', only 5 bars (sunAmount to thuAmount)
  }
}

class BarDataItem {
  final int x;
  final double y;
  BarDataItem({required this.x, required this.y});
}
