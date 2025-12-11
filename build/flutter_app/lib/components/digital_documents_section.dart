import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/digital_document.dart';
import '../models/chat_message.dart';
import '../view_models/app_view_model.dart';
import '../extensions/color_absher.dart';
import '../extensions/font_absher.dart';
import '../extensions/view_modifiers.dart';

class DigitalDocumentsSection extends StatelessWidget {
  final List<DigitalDocument> documents;

  const DigitalDocumentsSection({
    super.key,
    required this.documents,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // Section header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () {},
              child: Text(
                'عرض الكل',
                style: AbsherFonts.caption.copyWith(color: AbsherColors.green),
              ),
            ),
            Text(
              'وثائقي الرقمية',
              style: AbsherFonts.headline.copyWith(color: AbsherColors.textPrimary),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Horizontal scrolling document cards
        SizedBox(
          height: 144,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            reverse: true,
            itemCount: documents.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              return _DocumentCard(document: documents[index]);
            },
          ),
        ),
        const SizedBox(height: 8),
        // Info text
        Text(
          'يمكنك عرض جميع وثائقك الرقمية',
          style: AbsherFonts.small.copyWith(color: AbsherColors.textSecondary),
        ),
      ],
    );
  }
}

class _DocumentCard extends StatelessWidget {
  final DigitalDocument document;

  const _DocumentCard({required this.document});

  IconData get _iconData {
    switch (document.type) {
      case DocumentType.nationalID:
        return Icons.badge;
      case DocumentType.passport:
        return Icons.menu_book;
      case DocumentType.license:
        return Icons.directions_car;
    }
  }

  ServiceType get _serviceType {
    switch (document.type) {
      case DocumentType.nationalID:
        return ServiceType.nationalIdRenewal;
      case DocumentType.passport:
        return ServiceType.passportRenewal;
      case DocumentType.license:
        return ServiceType.drivingLicenseRenewal;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<AppViewModel>().navigateToReview(serviceType: _serviceType);
      },
      child: Container(
        width: 100,
        height: 120,
        padding: const EdgeInsets.all(12),
        decoration: AbsherCardDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Icon
            Icon(_iconData, size: 32, color: document.color),
            const SizedBox(height: 8),
            // Title
            Text(
              document.title,
              style: AbsherFonts.body.copyWith(color: AbsherColors.textPrimary),
              textAlign: TextAlign.right,
            ),
            const Spacer(),
            // Status
            if (document.status == DocumentStatus.expiringSoon &&
                document.daysRemaining != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AbsherColors.orange.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'متبقي ${document.daysRemaining} يومًا',
                  style: AbsherFonts.small.copyWith(color: AbsherColors.orange),
                ),
              )
            else if (document.status == DocumentStatus.expired)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'انتهت',
                  style: AbsherFonts.small.copyWith(color: Colors.red),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
