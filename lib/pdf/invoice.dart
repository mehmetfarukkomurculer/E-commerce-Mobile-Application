import 'package:untitled3/pdf/customerPdf.dart';
import 'package:untitled3/pdf/supplierPdf.dart';

class Invoice {
  final InvoiceInfo info;
  final SupplierPDF supplierPDF;
  final CustomerPDF customerPDF;
  final List<InvoiceItem> items;

  const Invoice({
    required this.info,
    required this.supplierPDF,
    required this.customerPDF,
    required this.items,
  });
}

class InvoiceInfo {
  final String description;
  final String number;
  final DateTime date;
  final DateTime dueDate;

  const InvoiceInfo({
    required this.description,
    required this.number,
    required this.date,
    required this.dueDate,
  });
}

class InvoiceItem {
  final String description;
  final int quantity;
  final double total;
  final double unitPrice;

  const InvoiceItem({
    required this.description,
    required this.quantity,
    required this.total,
    required this.unitPrice,
  });
}