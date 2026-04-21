import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:linguista_ios/constants/custom_funcs/snackbar.dart';

import '../../../constants/custom_widgets/FormFieldDecorator.dart';
import '../../../constants/custom_widgets/gradient_button.dart';
import '../../../constants/input_formatter.dart';
import '../../../constants/text_styles.dart';
import '../../../constants/utils.dart';
import '../../../controllers/students/student_controller.dart';

class AdminStudentPaymentHistory extends StatefulWidget {
  final String uniqueId;
  final String id;
  final String name;
  final String surname;
  final List paidMonths;

  const AdminStudentPaymentHistory({
    super.key,
    required this.uniqueId,
    required this.id,
    required this.name,
    required this.surname,
    required this.paidMonths,
  });

  @override
  State<AdminStudentPaymentHistory> createState() =>
      _AdminStudentPaymentHistoryState();
}

class _AdminStudentPaymentHistoryState
    extends State<AdminStudentPaymentHistory> with SingleTickerProviderStateMixin {
  final StudentController studentController = Get.put(StudentController());
  final _formKey = GlobalKey<FormState>();
  final GetStorage box = GetStorage();

  List<String> months = getFormattedMonthsOfCurrentYear();

  void _openPaymentSheet({
    required BuildContext context,
    required bool isEdit,
    Map<String, dynamic>? paymentItem,
  }) {
    final RxString paymentType =
        ((paymentItem?['paymentType'] ?? 'Naqt')).toString().obs;

    if (isEdit && paymentItem != null) {
      studentController.payment.text =
          (paymentItem['paidSum'] ?? '').toString();
      studentController.paymentComment.text =
          (paymentItem['paymentCommentary'] ?? '').toString();
      studentController.paidDate.value =
          (paymentItem['paidDate'] ?? '').toString();
    } else {
      studentController.payment.clear();
      studentController.paymentComment.clear();
      studentController.paidDate.value = '';
      paymentType.value = 'Naqt';
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Form(
            key: _formKey,
            child: Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: SafeArea(
                top: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 42,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    const SizedBox(height: 12),

                    Row(
                      children: [
                        Text(
                          isEdit ? "Edit payment" : "Add fee",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () => Get.back(),
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    TextFormField(
                      keyboardType: TextInputType.number,
                      inputFormatters: [ThousandSeparatorInputFormatter()],
                      controller: studentController.payment,
                      decoration: buildInputDecoratione('Price'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Maydonlar bo'sh bo'lmasligi kerak";
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 10),

                    TextFormField(
                      keyboardType: TextInputType.text,
                      controller: studentController.paymentComment,
                      decoration: buildInputDecoratione('Commentary'),
                    ),

                    const SizedBox(height: 12),

                    Align(
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        "To'lov turi",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),

                    Obx(
                          () => Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () => paymentType.value = 'Naqt',
                              child: Container(
                                height: 42,
                                decoration: BoxDecoration(
                                  color: paymentType.value == 'Naqt'
                                      ? Colors.green
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: paymentType.value == 'Naqt'
                                        ? Colors.green
                                        : Colors.grey.shade300,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    "Naqt",
                                    style: TextStyle(
                                      color: paymentType.value == 'Naqt'
                                          ? Colors.white
                                          : Colors.black,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: InkWell(
                              onTap: () => paymentType.value = 'Karta',
                              child: Container(
                                height: 42,
                                decoration: BoxDecoration(
                                  color: paymentType.value == 'Karta'
                                      ? Colors.blue
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: paymentType.value == 'Karta'
                                        ? Colors.blue
                                        : Colors.grey.shade300,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    "Karta",
                                    style: TextStyle(
                                      color: paymentType.value == 'Karta'
                                          ? Colors.white
                                          : Colors.black,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    Row(
                      children: [
                        Expanded(
                          child: Obx(
                                () => Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                studentController.paidDate.value.isEmpty
                                    ? 'Paid date tanlanmagan'
                                    : 'Paid date: ${studentController.paidDate.value}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: studentController.paidDate.value.isEmpty
                                      ? Colors.grey
                                      : Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        InkWell(
                          onTap: () {
                            studentController.showDate(
                              studentController.paidDate,
                            );
                          },
                          child: Container(
                            height: 44,
                            width: 44,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.calendar_month,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),


                    SizedBox(
                      width: double.infinity,
                      child: InkWell(
                        onTap: () {
                          if (_formKey.currentState!.validate() &&
                              studentController.paidDate.value.isNotEmpty) {
                            if (isEdit) {
                              studentController.editPayment(
                                widget.id,
                                paymentItem!['id'],
                                paymentType.value,
                              );
                            } else {
                              studentController.addPayment(
                                widget.id,
                                studentController.paidDate.value,
                                paymentType.value,
                              );
                            }
                          }
                        },
                        child: Obx(
                              () => CustomButton(
                            isLoading: studentController.isLoading.value,
                            text: isEdit
                                ? "Save Changes"
                                : 'confirm'.tr.capitalizeFirst!,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  String _formatMoney(String value) {
    final number = int.tryParse(value.replaceAll(' ', '')) ?? 0;
    final formatter = NumberFormat('#,###');
    return formatter.format(number).replaceAll(',', ' ');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: CupertinoColors.black,
          ),
          onPressed: () {
            Get.back();
          },
        ),
        title: Text(
          '${widget.name}'.capitalizeFirst! +
              " " +
              "${widget.surname}".capitalizeFirst! +
              "  payment history",
          style: appBarStyle.copyWith(
            color: CupertinoColors.black,
            fontSize: 12,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('LinguistaStudents')
              .where('items.uniqueId', isEqualTo: widget.uniqueId)
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return SizedBox(
                height: Get.height,
                width: Get.width,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text('No data'));
            }

            final payments = snapshot.data!.docs;
            final paymentList =
            List.from(payments[0]['items']['payments'] ?? []);

            if (paymentList.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 200),
                    Image.asset(
                      'assets/fee_not_charged.png',
                      width: 222,
                    ),
                    Text(
                      '${widget.name}'.capitalizeFirst! +
                          " " +
                          "${widget.surname}".capitalizeFirst! +
                          " has not any payments ",
                      style: const TextStyle(color: Colors.black, fontSize: 12),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              );
            }

            return Column(
              children: [
                for (int i = 0; i < paymentList.length; i++)
                  Container(
                    width: Get.width,
                    margin:
                    const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: const Color(0xFFF1F5F9),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: const Icon(
                                CupertinoIcons.money_dollar,
                                color: Colors.black,
                                size: 22,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    convertDate(
                                      "${paymentList[i]['paidDate']}",
                                    ),
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    "Payment",
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: ((paymentList[i]['paymentType'] ??
                                    'Naqt') ==
                                    'Karta')
                                    ? const Color(0xFFE0F2FE)
                                    : const Color(0xFFDCFCE7),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                "${paymentList[i]['paymentType'] ?? 'Naqt'}",
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: ((paymentList[i]['paymentType'] ??
                                      'Naqt') ==
                                      'Karta')
                                      ? const Color(0xFF0369A1)
                                      : const Color(0xFF15803D),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        Text(
                          "${_formatMoney(paymentList[i]['paidSum'].toString())} so'm",
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                          ),
                        ),

                        const SizedBox(height: 6),

                        if ((paymentList[i]['paymentCommentary'] ?? '')
                            .toString()
                            .trim()
                            .isNotEmpty)
                          Text(
                            "${paymentList[i]['paymentCommentary']}",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),

                        const SizedBox(height: 10),

                        Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: box.read('isLogged') != 'Linguista9'
                                    ? null
                                    : () {
                                  final item = Map<String, dynamic>.from(
                                    paymentList[i],
                                  );

                                  _openPaymentSheet(
                                    context: context,
                                    isEdit: true,
                                    paymentItem: item,
                                  );
                                },
                                borderRadius: BorderRadius.circular(12),
                                child: Container(
                                  height: 42,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF1F5F9),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(
                                    CupertinoIcons.pencil,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  if (box.read('isLogged') == 'Linguista9') {
                                    showCupertinoDialog(
                                      context: context,
                                      builder: (_) => CupertinoAlertDialog(
                                        title: const Text('Delete Payment'),
                                        content: const Text(
                                          'Haqiqatan ham shu to‘lovni o‘chirmoqchimisiz?',
                                        ),
                                        actions: [
                                          CupertinoDialogAction(
                                            child: const Text('Bekor qilish'),
                                            onPressed: () => Get.back(),
                                          ),
                                          CupertinoDialogAction(
                                            isDestructiveAction: true,
                                            child: const Text('O‘chirish'),
                                            onPressed: () {
                                              Get.back();
                                              studentController.deletePayment(
                                                widget.id,
                                                paymentList[i]['id'],
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    );
                                  } else {
                                    showCustomSnackBar(
                                      context,
                                      title: 'Warning',
                                      message: 'Only admin can change data',
                                      backgroundColor:
                                      CupertinoColors.systemYellow,
                                      icon: Icons.warning_rounded,
                                    );
                                  }
                                },
                                borderRadius: BorderRadius.circular(12),
                                child: Container(
                                  height: 42,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFEF2F2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(
                                    CupertinoIcons.delete,
                                    color: Colors.red,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 90),
              ],
            );
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        child: const Icon(CupertinoIcons.add, color: Colors.white),
        onPressed: () {
          studentController.payment.clear();
          studentController.paymentComment.clear();
          studentController.paidDate.value = '';

          _openPaymentSheet(
            context: context,
            isEdit: false,
          );
        },
      ),
    );
  }
}