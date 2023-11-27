import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goshare/features/menu_user/money-topup/money-topup-repository.dart';

final MoneyTopupControllerProvider =
    StateNotifierProvider<MoneyTopupController, bool>(
  (ref) => MoneyTopupController(
    moneyTopupRepository: ref.watch(moneyTopupRepositoryProvider),
  ),
);

class MoneyTopupController extends StateNotifier<bool> {
  final MoneyTopupRepository _moneyTopupRepository;
  MoneyTopupController({
    required MoneyTopupRepository moneyTopupRepository,
  })  : _moneyTopupRepository = moneyTopupRepository,
        super(false);
  Future<BalanceResult> getBalance(
    BuildContext context,
  ) async {
    final result = await _moneyTopupRepository.getBalance();
    return result;
  }

  Future<List<TransactionResult>> getTransaction(
    BuildContext context,
  ) async {
    final result = await _moneyTopupRepository.getTransaction();
    return result;
  }

  Future moneyTopup(
    int amount,
    BuildContext context,
  ) async {
    print(amount);
    final result = await _moneyTopupRepository.moneyTopup(amount);
    return result;
  }
}
