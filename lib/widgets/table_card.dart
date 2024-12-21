// import 'package:flutter/material.dart';
// import '../models/table_model.dart';
//
// class TableCard extends StatelessWidget {
//   final TableModel table;
//   final VoidCallback onTap;
//
//   const TableCard({
//     Key? key,
//     required this.table,
//     required this.onTap,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: table.isAvailable ? onTap : null,
//       child: Container(
//         decoration: BoxDecoration(
//           color: table.isAvailable ? Colors.yellow[100] : Colors.grey[300],
//           borderRadius: BorderRadius.circular(10),
//           border: Border.all(color: Colors.black),
//         ),
//         child: Center(
//           child: Text(
//             table.name,
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//               color: table.isAvailable ? Colors.black : Colors.grey,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
