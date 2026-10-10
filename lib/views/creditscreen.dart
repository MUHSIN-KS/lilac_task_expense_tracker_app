import 'package:flutter/material.dart';
import 'package:lilac_company_task/controller/craditcontroller.dart';
import 'package:lilac_company_task/models/creditmodel.dart';
import 'package:lilac_company_task/utils/apptheme.dart';
import 'package:lilac_company_task/utils/formatters.dart';
import 'package:lilac_company_task/utils/validators.dart';
import 'package:lilac_company_task/widgets/appheaders.dart';
import 'package:lilac_company_task/widgets/conformdialog.dart';
import 'package:lilac_company_task/widgets/emptystate.dart';
import 'package:lilac_company_task/widgets/labeledfield.dart';
import 'package:lilac_company_task/widgets/primarybotton.dart';
import 'package:provider/provider.dart';

class CreditScreen extends StatefulWidget {
  const CreditScreen({super.key});

  @override
  State<CreditScreen> createState() => _CreditScreenState();
}

class _CreditScreenState extends State<CreditScreen> {
  static const _creditTypes = ['Subscriptions', 'Loan', 'Bills', 'Other'];
  static const _planTypes = ['Monthly', 'Yearly', 'One-Time'];

  final _formKey = GlobalKey<FormState>();
  final _to = TextEditingController();
  final _amount = TextEditingController();
  String _creditType = _creditTypes.first;
  String _plan = _planTypes.first;
  DateTime _date = DateTime.now();

  @override
  void dispose() {
    _to.dispose();
    _amount.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final p = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (p != null) setState(() => _date = p);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final ctrl = context.read<CreditController>();
    final ok = await ctrl.add(
      CreditModel(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        creditType: _creditType,
        to: _to.text.trim(),
        date: _date,
        planType: _plan,
        amount: double.parse(_amount.text.trim()),
      ),
    );
    if (!mounted) return;
    if (ok) {
      _to.clear();
      _amount.clear();
      _formKey.currentState!.reset();
      setState(() => _date = DateTime.now());
      showMessage(context, 'Saved');
    } else {
      showMessage(context, ctrl.error ?? 'Something went wrong');
    }
  }

  bool _isToday(DateTime d) {
    final n = DateTime.now();
    return d.year == n.year && d.month == n.month && d.day == n.day;
  }

  @override
  Widget build(BuildContext context) {
    final credits = context.watch<CreditController>().items;

    return Column(
      children: [
        const AppHeader(title: 'Credit'),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    LabeledField(
                      label: 'Credit Type',
                      child: DropdownButtonFormField<String>(
                        value: _creditType,
                        decoration: fieldDecoration(),
                        items: _creditTypes
                            .map(
                              (e) => DropdownMenuItem(value: e, child: Text(e)),
                            )
                            .toList(),
                        onChanged: (v) => setState(() => _creditType = v!),
                      ),
                    ),
                    LabeledField(
                      label: 'To',
                      child: TextFormField(
                        controller: _to,
                        decoration: fieldDecoration(hint: 'e.g. Netflix'),
                        validator: (v) => Validators.required(v, 'Name'),
                      ),
                    ),
                    LabeledField(
                      label: 'Amount',
                      child: TextFormField(
                        controller: _amount,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: fieldDecoration(hint: '₹ 0.00'),
                        validator: Validators.amount,
                      ),
                    ),
                    LabeledField(
                      label: 'Date',
                      child: InkWell(
                        onTap: _pickDate,
                        child: InputDecorator(
                          decoration: fieldDecoration(
                            suffix: const Icon(
                              Icons.calendar_month_outlined,
                              size: 20,
                            ),
                          ),
                          child: Text(fullDate(_date)),
                        ),
                      ),
                    ),
                    LabeledField(
                      label: 'Plan Type',
                      child: DropdownButtonFormField<String>(
                        value: _plan,
                        decoration: fieldDecoration(),
                        items: _planTypes
                            .map(
                              (e) => DropdownMenuItem(value: e, child: Text(e)),
                            )
                            .toList(),
                        onChanged: (v) => setState(() => _plan = v!),
                      ),
                    ),
                    const SizedBox(height: 4),
                    PrimaryButton(label: 'Save', onPressed: _save),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              const Text(
                'Your Saved Lists',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
              ),
              const SizedBox(height: 8),
              if (credits.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: EmptyState(
                    message: 'Nothing saved yet.',
                    icon: Icons.account_balance_wallet_outlined,
                  ),
                )
              else
                ...credits.map(
                  (c) => Dismissible(
                    key: ValueKey(c.id),
                    direction: DismissDirection.endToStart,
                    confirmDismiss: (_) => confirmDialog(
                      context,
                      title: 'Delete entry?',
                      message: 'Remove "${c.to}" from your saved list?',
                    ),
                    onDismissed: (_) =>
                        context.read<CreditController>().delete(c.id),
                    background: Container(
                      color: AppColors.expense,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 16),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        border: Border(
                          bottom: BorderSide(color: Color(0xFFEEEEEE)),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  c.to,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                _isToday(c.date)
                                    ? const Text.rich(
                                        TextSpan(
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: AppColors.label,
                                          ),
                                          children: [
                                            TextSpan(text: 'Due '),
                                            TextSpan(
                                              text: 'Today',
                                              style: TextStyle(
                                                color: AppColors.expense,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : Text(
                                        'Due On ${shortDate(c.date)}',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: AppColors.label,
                                        ),
                                      ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                c.planType,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: AppColors.label,
                                ),
                              ),
                              Text(
                                money(c.amount),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
