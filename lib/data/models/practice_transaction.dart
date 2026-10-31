/// Practice Lab simulated transaction record.
class PracticeTransaction {
  final String id;
  final String recipientName;
  final String accountNumber;
  final String bankName;
  final double amount;
  final DateTime timestamp;
  final String type; // 'Transfer', 'Electricity Bill', 'Gas Bill', 'Credit'
  final String status; // 'Completed', 'Simulated'
  final String referenceNumber;
  final String note;
  final bool wasIndependent;

  const PracticeTransaction({
    required this.id,
    required this.recipientName,
    required this.accountNumber,
    required this.bankName,
    required this.amount,
    required this.timestamp,
    required this.type,
    this.status = 'Completed (Simulated)',
    required this.referenceNumber,
    this.note = '',
    this.wasIndependent = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'recipientName': recipientName,
      'accountNumber': accountNumber,
      'bankName': bankName,
      'amount': amount,
      'timestamp': timestamp.toIso8601String(),
      'type': type,
      'status': status,
      'referenceNumber': referenceNumber,
      'note': note,
      'wasIndependent': wasIndependent,
    };
  }

  factory PracticeTransaction.fromMap(Map<String, dynamic> map) {
    return PracticeTransaction(
      id: map['id'] as String,
      recipientName: map['recipientName'] as String,
      accountNumber: map['accountNumber'] as String,
      bankName: map['bankName'] as String,
      amount: (map['amount'] as num).toDouble(),
      timestamp: DateTime.tryParse(map['timestamp'] as String? ?? '') ?? DateTime.now(),
      type: map['type'] as String? ?? 'Transfer',
      status: map['status'] as String? ?? 'Completed (Simulated)',
      referenceNumber: map['referenceNumber'] as String? ?? '',
      note: map['note'] as String? ?? '',
      wasIndependent: map['wasIndependent'] as bool? ?? false,
    );
  }
}
