import 'package:flutter/material.dart';
import 'package:order_tracking/presentation/dialogs/transfer_dialog.dart';
import 'package:order_tracking/presentation/provider/get_pending_provider.dart';
import 'package:order_tracking/presentation/screens/home/home_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PendingOrderScreen extends StatefulWidget {
  const PendingOrderScreen({super.key});
  @override
  State<PendingOrderScreen> createState() => _PendingOrderScreenState();
}

class _PendingOrderScreenState extends State<PendingOrderScreen> {
  String? date;
  String? bid;

  Future<void> loadData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      bid = sharedPreferences.getString('branchId');
      date = sharedPreferences.getString('date');
    });
  }

  @override
  void initState() {
    super.initState();
    loadData().then((_) {
      if (bid != null && date != null) {
        Provider.of<GetPendingProvider>(context, listen: false)
            .getPending(date, bid!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Orange theme colors
    final primaryOrange = Colors.orange[700];
  
    final mediumOrange = Colors.orange[100];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        elevation: 0,
        title: const Text("Pending Orders"),
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const HomeScreen()));
            },
            icon: const Icon(Icons.arrow_back)),
        centerTitle: true,
      ),
      body: Consumer<GetPendingProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return Center(
              child: CircularProgressIndicator(
                color: primaryOrange,
              ),
            );
          }
          if (provider.getPendingOrders.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.hourglass_empty,
                    size: 70,
                    color: Colors.orange[300],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "No pending orders available",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.orange[800],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          }
          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: ListView.builder(
              itemCount: provider.getPendingOrders.length,
              itemBuilder: (context, index) {
                final order = provider.getPendingOrders[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.orange.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header with Order ID and Type
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: mediumOrange,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.receipt_long, color: primaryOrange),
                                const SizedBox(width: 8),
                                Text(
                                  "Order #${order.orderId}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: primaryOrange,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: primaryOrange,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                order.orderType ?? "N/A",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Order Details
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildOrderInfoSection(
                              "Order Information",
                              [
                                _buildInfoRow("Table Name", order.tablename,
                                    Icons.table_restaurant, primaryOrange),
                                _buildInfoRow("Total Amount", order.totalAmt,
                                    Icons.attach_money, primaryOrange),
                              ],
                            ),
                            Divider(height: 24, color: Colors.orange[200]),
                            _buildOrderInfoSection(
                              "Customer Details",
                              [
                                _buildInfoRow("Name", order.customerName,
                                    Icons.person, primaryOrange),
                                _buildInfoRow("Address", order.customerAddress,
                                    Icons.location_on, primaryOrange),
                                _buildInfoRow("Phone", order.customerCellNo,
                                    Icons.phone, primaryOrange),
                              ],
                            ),
                            Divider(height: 24, color: Colors.orange[200]),
                            _buildOrderInfoSection(
                              "Staff Information",
                              [
                                _buildInfoRow("Waiter", order.waiterName,
                                    Icons.person_outline, primaryOrange),
                                _buildInfoRow("Rider", order.riderName,
                                    Icons.delivery_dining, primaryOrange),
                              ],
                            ),

                            // Transfer to Dine In Button
                            const SizedBox(height: 16),
                            order.orderType == 'Take Away' ||
                                    order.orderType == "Home Delivery"
                                ? GestureDetector(
                                    onTap: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return  TransferDialog(
                                              orderId: provider.getPendingOrders[index].orderId,
                                              orderMode: provider.getPendingOrders[index].orderType,
                                            );
                                          });
                                    },
                                    child: Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12),
                                      decoration: BoxDecoration(
                                        color: primaryOrange,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const Text(
                                        'Transfer to Dine In',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                  )
                                : Container(),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildOrderInfoSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 12),
        ...children,
      ],
    );
  }

  Widget _buildInfoRow(
      String label, String? value, IconData icon, Color? iconColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 18,
            color: iconColor?.withOpacity(0.8),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value?.isNotEmpty == true ? value! : "N/A",
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
