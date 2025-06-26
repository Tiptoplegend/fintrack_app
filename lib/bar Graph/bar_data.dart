// import 'package:fintrack_app/bar%20Graph/individual_bar.dart';

// class BarData {
//   final double sunAmount;
//   final double monAmount;
//   final double tueAmount;
//   final double wedAmount;
//   final double thuAmount;
//   final double friAmount;
//   final double satAmount;
//   final String filter;

//   BarData({
//     required this.sunAmount,
//     required this.monAmount,
//     required this.tueAmount,
//     required this.wedAmount,
//     required this.thuAmount,
//     required this.friAmount,
//     required this.satAmount,
//     required this.filter,
//   });

//   List<IndividualBar> barData = [];

//   void initializedBarData() {
//     barData = [
//       IndividualBar(x: 0, y: sunAmount),
//       IndividualBar(x: 1, y: monAmount),
//       IndividualBar(x: 2, y: tueAmount),
//       IndividualBar(x: 3, y: wedAmount),
//       IndividualBar(x: 4, y: thuAmount),
//       if (filter != 'Yearly') ...[
//         IndividualBar(x: 5, y: friAmount),
//         IndividualBar(x: 6, y: satAmount),
//       ],
//     ];
//   }
// }
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
