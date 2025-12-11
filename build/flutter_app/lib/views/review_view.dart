import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../view_models/app_view_model.dart';
import '../models/service_details.dart';
import '../models/user_profile.dart';
import '../models/license_verification.dart';
import '../extensions/color_absher.dart';
import '../extensions/font_absher.dart';
import '../extensions/view_modifiers.dart';
import '../components/license_header_card.dart';

class ReviewView extends StatefulWidget {
  final ServiceDetails serviceDetails;
  final UserProfile userProfile;

  const ReviewView({
    super.key,
    required this.serviceDetails,
    required this.userProfile,
  });

  @override
  State<ReviewView> createState() => _ReviewViewState();
}

class _ReviewViewState extends State<ReviewView> {
  bool _isBooked = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = context.read<AppViewModel>();
      viewModel.updateTotalFeeAmount(widget.serviceDetails.feeAmount);
      viewModel.ensureVerificationFreshness();
    });
  }

  String _formatCurrency(double amount) {
    final formatter = NumberFormat('#,###', 'ar');
    return '${formatter.format(amount)} ريال';
  }

  String _formatPercentage(double value) {
    return '${(value * 100).round()}٪';
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppViewModel>(
      builder: (context, viewModel, child) {
        return Scaffold(
          backgroundColor: AbsherColors.background,
          body: SafeArea(
            child: Column(
              children: [
                // Navigation bar
                _buildNavigationBar(viewModel),
                // Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        LicenseHeaderCard(
                          profile: widget.userProfile,
                          serviceTitle: widget.serviceDetails.serviceTitle,
                        ),
                        const SizedBox(height: 24),
                        _buildBeneficiaryStatusSection(),
                        const SizedBox(height: 24),
                        _buildFeeBreakdownSection(),
                        const SizedBox(height: 24),
                        _buildFeesSection(),
                        const SizedBox(height: 24),
                        if (viewModel.remainingAmount > 0)
                          _buildSplitPaymentSection(viewModel),
                        if (viewModel.remainingAmount > 0) const SizedBox(height: 24),
                        _buildRequirementsSection(viewModel),
                        const SizedBox(height: 24),
                        _buildMedicalCheckSection(viewModel),
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          bottomSheet: _buildApproveButton(viewModel),
        );
      },
    );
  }

  Widget _buildNavigationBar(AppViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(color: AbsherColors.cardBackground),
      child: Row(
        children: [
          IconButton(
            onPressed: () => viewModel.currentScreen = Screen.home,
            icon: const Icon(Icons.chevron_right, color: AbsherColors.green),
          ),
          Expanded(
            child: Text(
              widget.serviceDetails.serviceTitle,
              style: AbsherFonts.headline.copyWith(color: AbsherColors.textPrimary),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 40),
        ],
      ),
    );
  }

  Widget _buildBeneficiaryStatusSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: AbsherCardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  widget.serviceDetails.beneficiaryStatus,
                  style: AbsherFonts.body.copyWith(color: AbsherColors.textPrimary),
                  textAlign: TextAlign.right,
                ),
              ),
              const SizedBox(width: 12),
              const Icon(Icons.warning, color: AbsherColors.orange, size: 24),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'حالة المستفيد',
            style: AbsherFonts.caption.copyWith(color: AbsherColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildFeeBreakdownSection() {
    final isFree = widget.serviceDetails.feeAmount == 0;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: AbsherCardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            'تفاصيل الرسوم',
            style: AbsherFonts.headline.copyWith(color: AbsherColors.textPrimary),
          ),
          const SizedBox(height: 16),
          // Base fee row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isFree ? 'مجاني' : _formatCurrency(widget.serviceDetails.baseFee),
                style: AbsherFonts.body.copyWith(
                  color: isFree ? AbsherColors.green : AbsherColors.textPrimary,
                ),
              ),
              Text(
                widget.serviceDetails.serviceTitle,
                style: AbsherFonts.body.copyWith(color: AbsherColors.textSecondary),
              ),
            ],
          ),
          // Late fee row
          if (widget.serviceDetails.isLate && widget.serviceDetails.lateFee > 0) ...[
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatCurrency(widget.serviceDetails.lateFee),
                  style: AbsherFonts.body.copyWith(color: AbsherColors.orange),
                ),
                Text(
                  'رسوم تأخير',
                  style: AbsherFonts.body.copyWith(color: AbsherColors.textSecondary),
                ),
              ],
            ),
          ],
          const SizedBox(height: 12),
          const Divider(color: AbsherColors.textSecondary),
          const SizedBox(height: 12),
          // Total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isFree ? 'مجاني' : _formatCurrency(widget.serviceDetails.feeAmount),
                style: AbsherFonts.headline.copyWith(
                  color: isFree ? AbsherColors.green : AbsherColors.mint,
                ),
              ),
              Text(
                'المجموع',
                style: AbsherFonts.body.copyWith(color: AbsherColors.textPrimary),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeesSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: AbsherCardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      widget.serviceDetails.fees,
                      style: AbsherFonts.headline.copyWith(color: AbsherColors.textPrimary),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.serviceDetails.paymentMethod,
                      style: AbsherFonts.caption.copyWith(color: AbsherColors.textSecondary),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              const Icon(Icons.credit_card, color: AbsherColors.mint, size: 24),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'الرسوم',
            style: AbsherFonts.caption.copyWith(color: AbsherColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildSplitPaymentSection(AppViewModel viewModel) {
    final percentage = viewModel.totalFeeAmount > 0
        ? viewModel.selectedPaymentAmount / viewModel.totalFeeAmount
        : 0.0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: AbsherCardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            'قسّم دفعتك كما يناسبك',
            style: AbsherFonts.headline.copyWith(color: AbsherColors.textPrimary),
          ),
          const SizedBox(height: 4),
          Text(
            'اختر مبلغًا بين ٠ ريال والمتبقي لديك من الرسوم.',
            style: AbsherFonts.caption.copyWith(color: AbsherColors.textSecondary),
          ),
          const SizedBox(height: 16),
          Text(
            'المبلغ المختار',
            style: AbsherFonts.caption.copyWith(color: AbsherColors.textSecondary),
          ),
          Text(
            '${_formatCurrency(viewModel.selectedPaymentAmount)} (${_formatPercentage(percentage)})',
            style: AbsherFonts.headline.copyWith(color: AbsherColors.mint),
          ),
          const SizedBox(height: 16),
          Slider(
            value: viewModel.selectedPaymentAmount.clamp(0, viewModel.remainingAmount),
            min: 0,
            max: viewModel.remainingAmount,
            divisions: (viewModel.remainingAmount / 10).round().clamp(1, 100),
            activeColor: AbsherColors.orange,
            inactiveColor: AbsherColors.cardBorder,
            onChanged: (value) {
              viewModel.selectedPaymentAmount = value;
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formatCurrency(0),
                style: AbsherFonts.caption.copyWith(color: AbsherColors.textSecondary),
              ),
              Text(
                'المتبقي ${_formatCurrency(viewModel.remainingAmount)}',
                style: AbsherFonts.caption.copyWith(color: AbsherColors.textSecondary),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRequirementsSection(AppViewModel viewModel) {
    return _VerificationStatusCard(
      title: VerificationItemType.requirements.title,
      icon: Icons.description,
      accentColor: AbsherColors.lightGreen,
      fallbackHeadline: widget.serviceDetails.requirementsStatus,
      proof: viewModel.verificationSnapshot?.item(VerificationItemType.requirements),
      state: viewModel.verificationState,
      refreshAction: viewModel.refreshVerification,
    );
  }

  Widget _buildMedicalCheckSection(AppViewModel viewModel) {
    return _VerificationStatusCard(
      title: VerificationItemType.medicalExam.title,
      icon: Icons.favorite,
      accentColor: AbsherColors.green,
      fallbackHeadline: widget.serviceDetails.medicalCheckStatus,
      proof: viewModel.verificationSnapshot?.item(VerificationItemType.medicalExam),
      state: viewModel.verificationState,
      refreshAction: viewModel.refreshVerification,
    );
  }

  Widget _buildApproveButton(AppViewModel viewModel) {
    final isFree = widget.serviceDetails.feeAmount == 0;

    return Container(
      padding: const EdgeInsets.all(16),
      color: AbsherColors.background,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: _isBooked ? AbsherColors.green : AbsherColors.mint,
          foregroundColor: AbsherColors.background,
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onPressed: viewModel.isLoading || _isBooked ||
                (!isFree && (viewModel.selectedPaymentAmount <= 0 || viewModel.remainingAmount <= 0))
            ? null
            : () async {
                if (_isBooked) return;

                if (isFree) {
                  setState(() => _isBooked = true);
                  await Future.delayed(const Duration(milliseconds: 1500));
                  viewModel.approveFreeService();
                } else {
                  viewModel.approveService();
                }
              },
        child: viewModel.isLoading
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: AbsherColors.background,
                      strokeWidth: 2,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'جار المعالجة...',
                    style: AbsherFonts.headline.copyWith(color: AbsherColors.background),
                  ),
                ],
              )
            : _isBooked
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.check_circle, size: 24),
                      const SizedBox(width: 12),
                      Text(
                        'تم الحجز ✓',
                        style: AbsherFonts.headline.copyWith(color: AbsherColors.background),
                      ),
                    ],
                  )
                : Text(
                    isFree
                        ? 'تأكيد التجديد مجاناً'
                        : 'دفع ${_formatCurrency(viewModel.selectedPaymentAmount)} الآن',
                    style: AbsherFonts.headline.copyWith(color: AbsherColors.background),
                  ),
      ),
    );
  }
}

class _VerificationStatusCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color accentColor;
  final String fallbackHeadline;
  final VerificationProof? proof;
  final VerificationState state;
  final VoidCallback refreshAction;

  const _VerificationStatusCard({
    required this.title,
    required this.icon,
    required this.accentColor,
    required this.fallbackHeadline,
    required this.proof,
    required this.state,
    required this.refreshAction,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormatter = DateFormat('d MMMM yyyy, HH:mm', 'ar');

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: AbsherCardDecoration(),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          proof?.headline ?? fallbackHeadline,
                          style: AbsherFonts.body.copyWith(color: AbsherColors.textPrimary),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          proof != null
                              ? 'تمت مزامنتها آليًا من ${proof!.sourceSystem}'
                              : title,
                          style: AbsherFonts.caption.copyWith(color: AbsherColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Icon(icon, color: accentColor, size: 24),
                ],
              ),
              if (proof != null) ...[
                const SizedBox(height: 8),
                Text(
                  proof!.detail,
                  style: AbsherFonts.caption.copyWith(color: AbsherColors.textSecondary),
                  textAlign: TextAlign.right,
                ),
                Text(
                  'المصدر: ${proof!.sourceSystem} • ${dateFormatter.format(proof!.lastSynced)}',
                  style: AbsherFonts.caption.copyWith(color: AbsherColors.textSecondary),
                ),
                Text(
                  'المرجع: ${proof!.referenceCode}',
                  style: AbsherFonts.caption.copyWith(color: AbsherColors.textSecondary),
                ),
              ] else
                _buildFallbackContent(),
            ],
          ),
          if (proof != null)
            Positioned(
              top: 0,
              left: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: accentColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  proof!.status.localizedLabel,
                  style: AbsherFonts.caption.copyWith(color: accentColor),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFallbackContent() {
    switch (state) {
      case VerificationState.loading:
        return Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(color: accentColor, strokeWidth: 2),
              ),
              const SizedBox(width: 8),
              Text(
                'جارٍ التحقق من $title...',
                style: AbsherFonts.caption.copyWith(color: AbsherColors.textSecondary),
              ),
            ],
          ),
        );
      case VerificationState.failed:
        return Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'فشل التحقق',
                style: AbsherFonts.caption.copyWith(color: AbsherColors.orange),
              ),
              TextButton(
                onPressed: refreshAction,
                child: Text(
                  'إعادة المحاولة',
                  style: AbsherFonts.caption.copyWith(color: AbsherColors.green),
                ),
              ),
            ],
          ),
        );
      default:
        return const SizedBox.shrink();
    }
  }
}
