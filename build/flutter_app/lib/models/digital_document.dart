import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

enum DocumentType {
  nationalID,
  passport,
  license,
}

enum DocumentStatus {
  valid,
  expiringSoon,
  expired,
}

class DigitalDocument {
  final String id;
  final DocumentType type;
  final String title;
  final DocumentStatus status;
  final Color color;
  final int? daysRemaining;

  DigitalDocument({
    String? id,
    required this.type,
    required this.title,
    required this.status,
    required this.color,
    this.daysRemaining,
  }) : id = id ?? const Uuid().v4();

  static List<DigitalDocument> get mockDocuments => [
        DigitalDocument(
          type: DocumentType.nationalID,
          title: 'هوية مواطن',
          status: DocumentStatus.valid,
          color: Colors.green,
          daysRemaining: null,
        ),
        DigitalDocument(
          type: DocumentType.passport,
          title: 'جواز السفر',
          status: DocumentStatus.valid,
          color: Colors.purple,
          daysRemaining: null,
        ),
        DigitalDocument(
          type: DocumentType.license,
          title: 'رخصة',
          status: DocumentStatus.expiringSoon,
          color: Colors.red,
          daysRemaining: 45,
        ),
      ];

  /// Mock expired National ID for testing late fee scenario
  static DigitalDocument get expiredNationalID => DigitalDocument(
        type: DocumentType.nationalID,
        title: 'هوية مواطن',
        status: DocumentStatus.expired,
        color: Colors.red,
        daysRemaining: null,
      );
}
