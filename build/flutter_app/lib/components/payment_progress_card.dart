import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../extensions/color_absher.dart';
import '../extensions/font_absher.dart';
import '../extensions/view_modifiers.dart';

class PaymentProgressCard extends StatelessWidget {
  final double paidAmount;
  final double totalAmount;

  const PaymentProgressCard({
    super.key,
    required this.paidAmount,
    required this.totalAmount,
  });

  double get _remainingAmount => (totalAmount - paidAmount).clamp(0, double.infinity);

  double get _paidPercentage {
    if (totalAmount <= 0) return 0;
    return paidAmount / totalAmount;
  }

  double get _remainingPercentage {
    if (totalAmount <= 0) return 0;
    return 1 - _paidPercentage;
  }

  String _formatCurrency(double amount) {
    final formatter = NumberFormat('#,###', 'ar');
    return '${formatter.format(amount)} ريال';
  }

  String _formatPercentage(double value) {
    final formatter = NumberFormat.percentPattern('ar');
    return formatter.format(value);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: AbsherCardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Header
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'تقدم الدفعات',
                style: AbsherFonts.headline.copyWith(color: AbsherColors.textPrimary),
              ),
              const SizedBox(height: 4),
              Text(
                'تابع ما تم دفعه والمتبقي بسهولة.',
                style: AbsherFonts.caption.copyWith(color: AbsherColors.textSecondary),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: _paidPercentage,
              backgroundColor: AbsherColors.cardBorder,
              valueColor: const AlwaysStoppedAnimation<Color>(AbsherColors.orange),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 16),
          // Stats
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Paid
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${_formatPercentage(_paidPercentage)} مدفوع',
                    style: AbsherFonts.body.copyWith(color: AbsherColors.mint),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatCurrency(paidAmount),
                    style: AbsherFonts.caption.copyWith(color: AbsherColors.textSecondary),
                  ),
                ],
              ),
              // Remaining
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${_formatPercentage(_remainingPercentage)} متبقٍ',
                    style: AbsherFonts.body.copyWith(color: AbsherColors.orange),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatCurrency(_remainingAmount),
                    style: AbsherFonts.caption.copyWith(color: AbsherColors.textSecondary),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
