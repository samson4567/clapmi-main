class TransactionHistoryFilterArgs {
  final String status;
  final String operation;
  final String startDate;
  final String endDate;

  const TransactionHistoryFilterArgs({
    this.status = '',
    this.operation = '',
    this.startDate = '',
    this.endDate = '',
  });

  bool get hasActiveFilters =>
      status.isNotEmpty ||
      operation.isNotEmpty ||
      startDate.isNotEmpty ||
      endDate.isNotEmpty;
}
