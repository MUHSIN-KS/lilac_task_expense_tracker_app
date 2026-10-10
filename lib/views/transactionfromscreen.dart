import 'package:flutter/material.dart';
import 'package:lilac_company_task/controller/transactioncontroller.dart';
import 'package:lilac_company_task/models/transactionmodel.dart';
import 'package:lilac_company_task/utils/apptheme.dart';
import 'package:lilac_company_task/utils/formatters.dart';
import 'package:lilac_company_task/utils/validators.dart';
import 'package:lilac_company_task/widgets/appheaders.dart';
import 'package:lilac_company_task/widgets/conformdialog.dart';
import 'package:lilac_company_task/widgets/labeledfield.dart';
import 'package:lilac_company_task/widgets/primarybotton.dart';
import 'package:provider/provider.dart';


const kCategories = [
  'Food',
  'Shopping',
  'Bills',
  'Transport',
  'Entertainment',
  'Health',
  'Salary',
  'Other'
];

class TransactionFormScreen extends StatefulWidget {
  final TransactionModel? existing;
  const TransactionFormScreen({super.key, this.existing});

  @override
  State<TransactionFormScreen> createState() => _TransactionFormScreenState();
}

class _TransactionFormScreenState extends State<TransactionFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _title;
  late final TextEditingController _amount;
  late final TextEditingController _desc;
  late TransactionType _type;
  late String _category;
  late DateTime _date;

  bool get _isEdit => widget.existing != null;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _title = TextEditingController(text: e?.title ?? '');
    _amount = TextEditingController(text: e == null ? '' : e.amount.toString());
    _desc = TextEditingController(text: e?.description ?? '');
    _type = e?.type ?? TransactionType.expense;
    _category = e?.category ?? kCategories.first;
    _date = e?.date ?? DateTime.now();
  }

  @override
  void dispose() {
    _title.dispose();
    _amount.dispose();
    _desc.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final ctrl = context.read<TransactionController>();
    final desc = _desc.text.trim();

    final model = TransactionModel(
      id: widget.existing?.id ?? DateTime.now().microsecondsSinceEpoch.toString(),
      title: _title.text.trim(),
      amount: double.parse(_amount.text.trim()),
      type: _type,
      category: _category,
      date: _date,
      description: desc.isEmpty ? null : desc,
    );

    final ok = _isEdit ? await ctrl.update(model) : await ctrl.add(model);
    if (!mounted) return;
    final messenger = ScaffoldMessenger.of(context);
    if (ok) {
      Navigator.of(context).pop();
      messenger.showSnackBar(SnackBar(
          content: Text(_isEdit ? 'Transaction updated' : 'Transaction added'),
          behavior: SnackBarBehavior.floating));
    } else {
      showMessage(context, ctrl.error ?? 'Something went wrong');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          AppHeader(title: _isEdit ? 'Edit Transaction' : 'Transaction', showBack: true),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(18),
              child: Form(
                key: _formKey,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 14,
                          offset: const Offset(0, 4))
                    ],
                  ),
                  child: Column(
                    children: [
                      LabeledField(
                        label: 'Transaction Type',
                        child: DropdownButtonFormField<TransactionType>(
                          value: _type,
                          decoration: fieldDecoration(),
                          items: const [
                            DropdownMenuItem(
                                value: TransactionType.expense, child: Text('Expense')),
                            DropdownMenuItem(
                                value: TransactionType.income, child: Text('Income')),
                          ],
                          onChanged: (v) => setState(() => _type = v!),
                        ),
                      ),
                      LabeledField(
                        label: 'Name',
                        child: TextFormField(
                          controller: _title,
                          textCapitalization: TextCapitalization.sentences,
                          decoration: fieldDecoration(hint: 'e.g. Netflix'),
                          validator: Validators.title,
                        ),
                      ),
                      LabeledField(
                        label: 'Amount',
                        child: TextFormField(
                          controller: _amount,
                          keyboardType:
                               TextInputType.numberWithOptions(decimal: true),
                          decoration: fieldDecoration(
                            hint: '₹ 0.00',
                            suffix: TextButton(
                              onPressed: _amount.clear,
                              child:  Text('Clear',
                                  style: TextStyle(fontSize: 11, color: AppColors.primary)),
                            ),
                          ),
                          validator: Validators.amount,
                        ),
                      ),
                      LabeledField(
                        label: 'Category',
                        child: DropdownButtonFormField<String>(
                          value: _category,
                          decoration: fieldDecoration(),
                          items: kCategories
                              .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                              .toList(),
                          onChanged: (v) => setState(() => _category = v!),
                          validator: (v) => Validators.required(v, 'Category'),
                        ),
                      ),
                      LabeledField(
                        label: 'Date',
                        child: InkWell(
                          onTap: _pickDate,
                          child: InputDecorator(
                            decoration: fieldDecoration(
                                suffix: const Icon(Icons.calendar_month_outlined, size: 20)),
                            child: Text(fullDate(_date)),
                          ),
                        ),
                      ),
                      LabeledField(
                        label: 'Description (optional)',
                        child: TextFormField(
                          controller: _desc,
                          maxLines: 3,
                          decoration: fieldDecoration(hint: 'Add a note'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 8, 18, 14),
              child: PrimaryButton(label: 'Save', onPressed: _save),
            ),
          ),
        ],
      ),
    );
  }
}