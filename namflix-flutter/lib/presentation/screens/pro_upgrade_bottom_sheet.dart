import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../../core/network/dio_client.dart';
import '../../core/theme/app_theme.dart';

const _kProductIds = {'namflix_pro_monthly', 'namflix_pro_annual'};

/// A draggable bottom sheet that prompts the user to upgrade to Pro.
/// Typically shown when a free user hits the 20-favorites limit.
class ProUpgradeBottomSheet extends StatefulWidget {
  const ProUpgradeBottomSheet({super.key});

  /// Show this bottom sheet from any [context].
  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const ProUpgradeBottomSheet(),
    );
  }

  @override
  State<ProUpgradeBottomSheet> createState() => _ProUpgradeBottomSheetState();
}

class _ProUpgradeBottomSheetState extends State<ProUpgradeBottomSheet> {
  late StreamSubscription<List<PurchaseDetails>> _purchaseSub;

  List<ProductDetails> _products = [];
  bool _storeAvailable = false;
  bool _loading = true;
  bool _purchasing = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _purchaseSub = InAppPurchase.instance.purchaseStream.listen(
      _onPurchaseUpdate,
      onError: (_) {},
    );
    _initialize();
  }

  @override
  void dispose() {
    _purchaseSub.cancel();
    super.dispose();
  }

  Future<void> _initialize() async {
    final available = await InAppPurchase.instance.isAvailable();
    if (!available) {
      setState(() { _storeAvailable = false; _loading = false; });
      return;
    }

    final response = await InAppPurchase.instance.queryProductDetails(_kProductIds);
    if (mounted) {
      setState(() {
        _storeAvailable = true;
        _products = response.productDetails..sort((a, b) => a.rawPrice.compareTo(b.rawPrice));
        _loading = false;
      });
    }
  }

  void _onPurchaseUpdate(List<PurchaseDetails> purchases) {
    for (final purchase in purchases) {
      switch (purchase.status) {
        case PurchaseStatus.pending:
          setState(() { _purchasing = true; });
        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          _verifyAndComplete(purchase);
        case PurchaseStatus.error:
          setState(() { _purchasing = false; _error = purchase.error?.message; });
          InAppPurchase.instance.completePurchase(purchase);
        case PurchaseStatus.canceled:
          setState(() { _purchasing = false; });
      }
    }
  }

  Future<void> _verifyAndComplete(PurchaseDetails purchase) async {
    final platform = Platform.isAndroid ? 'android' : 'ios';
    try {
      final res = await DioClient.instance.post('/billing/verify-iap', data: {
        'purchase_token': purchase.verificationData.serverVerificationData,
        'product_id': purchase.productID,
        'platform': platform,
      });
      await InAppPurchase.instance.completePurchase(purchase);
      if (mounted && res.data['data']?['is_pro'] == true) {
        Navigator.pop(context); // close sheet
        context.go('/live');
      }
    } on DioException {
      await InAppPurchase.instance.completePurchase(purchase);
      if (mounted) setState(() { _purchasing = false; _error = 'Verification failed. Try again.'; });
    }
  }

  void _subscribe(ProductDetails product) {
    if (_purchasing) return;
    setState(() { _error = null; });
    InAppPurchase.instance.buyNonConsumable(purchaseParam: PurchaseParam(productDetails: product));
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.4,
      maxChildSize: 0.92,
      expand: false,
      builder: (context, controller) => Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // Drag handle
            Padding(
              padding: const EdgeInsets.only(top: 12, bottom: 4),
              child: Container(
                width: 40, height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Expanded(
              child: ListView(
                controller: controller,
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
                children: [
                  // Header
                  Row(
                    children: [
                      const Text('NamFlix ', style: TextStyle(color: AppColors.textPrimary, fontSize: 22, fontWeight: FontWeight.w900)),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(colors: [Color(0xFFFBBF24), Color(0xFFFDE68A)]),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text('PRO', style: TextStyle(color: Color(0xFF78350F), fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Text('You\'ve reached the 20 favorites limit.',
                      style: TextStyle(color: AppColors.textSecondary, fontSize: 14)),
                  const SizedBox(height: 2),
                  const Text('Upgrade for unlimited favorites + more.',
                      style: TextStyle(color: AppColors.textMuted, fontSize: 12)),

                  const SizedBox(height: 20),

                  // Quick feature highlights
                  ...[
                    ('star', 'Unlimited favorites'),
                    ('history', '90-day watch history'),
                    ('hd', 'HD stream priority'),
                    ('block', 'Ad-free experience'),
                  ].map((item) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        const Icon(Icons.check_circle_rounded, color: Color(0xFF4ADE80), size: 18),
                        const SizedBox(width: 10),
                        Text(item.$2, style: const TextStyle(color: AppColors.textPrimary, fontSize: 14)),
                      ],
                    ),
                  )),

                  const SizedBox(height: 20),

                  if (_error != null) ...[
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.red.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(_error!, style: const TextStyle(color: Colors.redAccent, fontSize: 12)),
                    ),
                    const SizedBox(height: 12),
                  ],

                  // Products
                  if (_loading)
                    const Center(child: Padding(
                      padding: EdgeInsets.all(16),
                      child: CircularProgressIndicator(color: AppColors.accentRed, strokeWidth: 2),
                    ))
                  else if (!_storeAvailable)
                    const Text('In-app purchases unavailable.', style: TextStyle(color: AppColors.textMuted))
                  else ...[
                    // Annual (best value)
                    if (_products.any((p) => p.id == 'namflix_pro_annual'))
                      _BottomSheetProductTile(
                        product: _products.firstWhere((p) => p.id == 'namflix_pro_annual'),
                        label: 'Annual',
                        sublabel: 'Save 44%',
                        highlighted: true,
                        onTap: _purchasing ? null : () => _subscribe(
                          _products.firstWhere((p) => p.id == 'namflix_pro_annual'),
                        ),
                        loading: _purchasing,
                      ),
                    const SizedBox(height: 10),
                    if (_products.any((p) => p.id == 'namflix_pro_monthly'))
                      _BottomSheetProductTile(
                        product: _products.firstWhere((p) => p.id == 'namflix_pro_monthly'),
                        label: 'Monthly',
                        highlighted: false,
                        onTap: _purchasing ? null : () => _subscribe(
                          _products.firstWhere((p) => p.id == 'namflix_pro_monthly'),
                        ),
                        loading: _purchasing,
                      ),
                  ],

                  const SizedBox(height: 16),
                  Center(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Maybe Later', style: TextStyle(color: AppColors.textMuted)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomSheetProductTile extends StatelessWidget {
  final ProductDetails product;
  final String label;
  final String? sublabel;
  final bool highlighted;
  final VoidCallback? onTap;
  final bool loading;

  const _BottomSheetProductTile({
    required this.product,
    required this.label,
    this.sublabel,
    required this.highlighted,
    this.onTap,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          border: Border.all(
            color: highlighted ? const Color(0xFFFBBF24) : AppColors.border,
            width: highlighted ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(14),
          color: highlighted ? Color(0xFFFBBF24).withValues(alpha: 0.07) : Colors.transparent,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: TextStyle(
                    color: highlighted ? const Color(0xFFFBBF24) : AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  )),
                  if (sublabel != null)
                    Text(sublabel!, style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
                ],
              ),
            ),
            Text(product.price, style: TextStyle(
              color: highlighted ? const Color(0xFFFBBF24) : AppColors.textPrimary,
              fontWeight: FontWeight.w800,
              fontSize: 18,
            )),
            const SizedBox(width: 12),
            if (loading)
              const SizedBox(width: 20, height: 20,
                  child: CircularProgressIndicator(color: AppColors.accentRed, strokeWidth: 2))
            else
              Icon(
                Icons.arrow_forward_rounded,
                color: highlighted ? const Color(0xFFFBBF24) : AppColors.textMuted,
                size: 18,
              ),
          ],
        ),
      ),
    );
  }
}
