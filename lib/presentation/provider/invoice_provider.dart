import 'package:flutter/material.dart';
import 'package:order_tracking/data/models/invoice_model.dart';


class InvoiceProvider extends ChangeNotifier {
  InvoiceModel? _invoiceModel;

  InvoiceModel? get invoiceModel => _invoiceModel;

  void setInvoice(InvoiceModel invoice) {
    _invoiceModel = invoice;
    notifyListeners(); 
  }
}
