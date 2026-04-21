import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TotalEarning extends StatelessWidget {
  const TotalEarning({super.key});

  String formatMoney(num value) {
    final formatter = NumberFormat('#,###');
    return formatter.format(value).replaceAll(',', ' ');
  }

  num parseMoney(dynamic value) {
    if (value == null) return 0;
    final cleaned = value.toString().replaceAll(' ', '').trim();
    return num.tryParse(cleaned) ?? 0;
  }

  DateTime? parsePaymentDate(dynamic value) {
    if (value == null || value.toString().trim().isEmpty) return null;

    try {
      final raw = value.toString().trim();

      if (raw.contains('-')) {
        final parts = raw.split('-');

        if (parts.length == 3 && parts[0].length == 4) {
          return DateTime.parse(raw);
        }

        if (parts.length == 3 && parts[2].length == 4) {
          return DateFormat('dd-MM-yyyy').parse(raw);
        }
      }

      return null;
    } catch (_) {
      return null;
    }
  }

  String formatDate(dynamic value) {
    final parsed = parsePaymentDate(value);
    if (parsed == null) return '-';
    return DateFormat('dd MMM yyyy').format(parsed);
  }

  bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  List<Map<String, dynamic>> extractPayments(List<QueryDocumentSnapshot> docs) {
    final List<Map<String, dynamic>> allPayments = [];

    for (final doc in docs) {
      final data = doc.data() as Map<String, dynamic>;
      final items = Map<String, dynamic>.from(data['items'] ?? {});
      final studentName = (items['name'] ?? '').toString();
      final studentSurname = (items['surname'] ?? '').toString();
      final payments = List.from(items['payments'] ?? []);

      for (final item in payments) {
        final payment = Map<String, dynamic>.from(item);
        payment['studentName'] = studentName;
        payment['studentSurname'] = studentSurname;
        payment['paymentType'] =
        (payment['paymentType'] ?? 'Naqt').toString().trim().isEmpty
            ? 'Naqt'
            : payment['paymentType'];
        allPayments.add(payment);
      }
    }

    allPayments.sort((a, b) {
      final aDate = parsePaymentDate(a['paidDate']) ?? DateTime(2000);
      final bDate = parsePaymentDate(b['paidDate']) ?? DateTime(2000);
      return bDate.compareTo(aDate);
    });

    return allPayments;
  }

  List<Map<String, dynamic>> filterByMonth(
      List<Map<String, dynamic>> payments,
      DateTime month,
      ) {
    return payments.where((item) {
      final date = parsePaymentDate(item['paidDate']);
      if (date == null) return false;
      return date.year == month.year && date.month == month.month;
    }).toList();
  }

  Widget statItem({
    required String title,
    required String amount,
    required IconData icon,
    required Color bg,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 34,
            width: 34,
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 18),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              color: Colors.white.withOpacity(0.75),
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            amount,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget paymentCard(Map<String, dynamic> item) {
    final isCard = (item['paymentType'] ?? 'Naqt') == 'Karta';

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              color: isCard
                  ? const Color(0xFFE0F2FE)
                  : const Color(0xFFDCFCE7),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              isCard
                  ? CupertinoIcons.creditcard_fill
                  : CupertinoIcons.money_dollar_circle_fill,
              color:
              isCard ? const Color(0xFF0369A1) : const Color(0xFF15803D),
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${item['studentName'] ?? ''} ${item['studentSurname'] ?? ''}"
                      .trim()
                      .isEmpty
                      ? "Noma'lum talaba"
                      : "${item['studentName'] ?? ''} ${item['studentSurname'] ?? ''}",
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  formatDate(item['paidDate']),
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),
                if ((item['paymentCommentary'] ?? '')
                    .toString()
                    .trim()
                    .isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    item['paymentCommentary'].toString(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 12,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "${formatMoney(parseMoney(item['paidSum']))} so'm",
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 6),
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: isCard
                      ? const Color(0xFFE0F2FE)
                      : const Color(0xFFDCFCE7),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  isCard ? "Karta" : "Naqt",
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: isCard
                        ? const Color(0xFF0369A1)
                        : const Color(0xFF15803D),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildList(List<Map<String, dynamic>> list) {
    if (list.isEmpty) {
      return const Center(
        child: Text(
          "To'lovlar topilmadi",
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 100),
      itemCount: list.length,
      itemBuilder: (context, index) => paymentCard(list[index]),
    );
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final previousMonth = DateTime(now.year, now.month - 1, 1);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: const Color(0xFFF8FAFC),
          foregroundColor: Colors.black,
          centerTitle: true,
          title: const Text(
            "Total Earning",
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('LinguistaStudents')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text("Ma'lumot topilmadi"));
            }

            final allPayments = extractPayments(snapshot.data!.docs);
            final currentMonthPayments = filterByMonth(allPayments, now);
            final lastMonthPayments = filterByMonth(allPayments, previousMonth);

            return Column(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 14),
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: const TabBar(
                    dividerColor: Colors.transparent,
                    indicatorSize: TabBarIndicatorSize.tab,
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.black,
                    indicator: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    tabs: [
                      Tab(text: "Hozirgi oy"),
                      Tab(text: "O‘tgan oy"),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: TabBarView(
                    children: [
                      _MonthTabContent(
                        title: DateFormat('MMMM yyyy').format(now),
                        payments: currentMonthPayments,
                        parseMoney: parseMoney,
                        formatMoney: formatMoney,
                        parsePaymentDate: parsePaymentDate,
                        isSameDay: isSameDay,
                        statItem: statItem,
                        buildList: buildList,
                      ),
                      _MonthTabContent(
                        title: DateFormat('MMMM yyyy').format(previousMonth),
                        payments: lastMonthPayments,
                        parseMoney: parseMoney,
                        formatMoney: formatMoney,
                        parsePaymentDate: parsePaymentDate,
                        isSameDay: isSameDay,
                        statItem: statItem,
                        buildList: buildList,
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _MonthTabContent extends StatelessWidget {
  final String title;
  final List<Map<String, dynamic>> payments;
  final num Function(dynamic value) parseMoney;
  final String Function(num value) formatMoney;
  final DateTime? Function(dynamic value) parsePaymentDate;
  final bool Function(DateTime a, DateTime b) isSameDay;
  final Widget Function({
  required String title,
  required String amount,
  required IconData icon,
  required Color bg,
  required Color iconColor,
  }) statItem;
  final Widget Function(List<Map<String, dynamic>> list) buildList;

  const _MonthTabContent({
    required this.title,
    required this.payments,
    required this.parseMoney,
    required this.formatMoney,
    required this.parsePaymentDate,
    required this.isSameDay,
    required this.statItem,
    required this.buildList,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    final cashPayments =
    payments.where((e) => (e['paymentType'] ?? 'Naqt') != 'Karta').toList();

    final cardPayments =
    payments.where((e) => (e['paymentType'] ?? 'Naqt') == 'Karta').toList();

    final todayPayments = payments.where((e) {
      final date = parsePaymentDate(e['paidDate']);
      if (date == null) return false;
      return isSameDay(date, now);
    }).toList();

    final totalAmount = payments.fold<num>(
      0,
          (sum, item) => sum + parseMoney(item['paidSum']),
    );

    final totalCash = cashPayments.fold<num>(
      0,
          (sum, item) => sum + parseMoney(item['paidSum']),
    );

    final totalCard = cardPayments.fold<num>(
      0,
          (sum, item) => sum + parseMoney(item['paidSum']),
    );

    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 0),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF0F172A),
                    Color(0xFF1E3A8A),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.12),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.75),
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "${formatMoney(totalAmount)} so'm",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Expanded(
                        child: statItem(
                          title: "Naqt",
                          amount: "${formatMoney(totalCash)} so'm",
                          icon: CupertinoIcons.money_dollar_circle_fill,
                          bg: const Color(0xFFDCFCE7),
                          iconColor: const Color(0xFF15803D),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: statItem(
                          title: "Karta",
                          amount: "${formatMoney(totalCard)} so'm",
                          icon: CupertinoIcons.creditcard_fill,
                          bg: const Color(0xFFE0F2FE),
                          iconColor: const Color(0xFF0369A1),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 14),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: const TabBar(
              dividerColor: Colors.transparent,
              indicatorSize: TabBarIndicatorSize.tab,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.black,
              indicator: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              tabs: [
                Tab(text: "Naqt"),
                Tab(text: "Karta"),
                Tab(text: "Bugun"),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: TabBarView(
              children: [
                buildList(cashPayments),
                buildList(cardPayments),
                buildList(todayPayments),
              ],
            ),
          ),
        ],
      ),
    );
  }
}