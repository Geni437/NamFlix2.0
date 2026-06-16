import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../../core/network/dio_client.dart';
import '../../core/theme/app_theme.dart';

const _kProductIds = {'namflix_pro_monthly', 'namflix_pro_annual'};

class ProScreen extends StatefulWidget {
  const ProScreen({super.key});

  @override
  State<ProScreen> createState() => _ProScreenState();
}

class _ProScreenState extends State<ProScreen> {
  late StreamSubscription<List<PurchaseDetails>> _purchaseSub;

  List<ProductDetails> _products = [];
  bool _storeAvailable = false;
  bool _loading = true;
  bool _purchasing = false;
  String? _statusMessage;

  @override
  void initState() {
    super.initState();
    _purchaseSub = InAppPurchase.instance.purchaseStream.listen(
      _onPurchaseUpdate,
      onError: (Object e) => _setStatus('Store error: $e'),
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
        _products = response.productDetails
          ..sort((a, b) => a.rawPrice.compareTo(b.rawPrice)); // monthly first
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
          setState(() { _purchasing = false; });
          _setStatus(purchase.error?.message ?? 'Purchase failed');
          InAppPurchase.instance.completePurchase(purchase);
        case PurchaseStatus.canceled:
          setState(() { _purchasing = false; });
      }
    }
  }

  Future<void> _verifyAndComplete(PurchaseDetails purchase) async {
    final platform = Platform.isAndroid ? 'android' : 'ios';
    final token = purchase.verificationData.serverVerificationData;

    try {
      final res = await DioClient.instance.post('/billing/verify-iap', data: {
        'purchase_token': token,
        'product_id': purchase.productID,
        'platform': platform,
      });

      final isPro = res.data['data']?['is_pro'] == true;

      await InAppPurchase.instance.completePurchase(purchase);

      if (mounted) {
        setState(() { _purchasing = false; });
        if (isPro) {
          _showSuccessDialog();
        } else {
          _setStatus('Verification failed. Please contact support.');
        }
      }
    } on DioException catch (e) {
      await InAppPurchase.instance.completePurchase(purchase);
      if (mounted) {
        setState(() { _purchasing = false; });
        _setStatus(e.response?.data?['message'] ?? 'Verification failed');
      }
    }
  }

  void _subscribe(ProductDetails product) {
    if (!_storeAvailable || _purchasing) return;
    setState(() { _statusMessage = null; });
    final param = PurchaseParam(productDetails: product);
    InAppPurchase.instance.buyNonConsumable(purchaseParam: param);
  }

  void _setStatus(String msg) {
    if (mounted) setState(() { _statusMessage = msg; _purchasing = false; });
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('Welcome to NamFlix Pro!',
            style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w700)),
        content: const Text('You now have unlimited favorites, 90-day history, and ad-free streaming.',
            style: TextStyle(color: AppColors.textSecondary)),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.go('/live');
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.accentRed),
            child: const Text('Start Watching', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textSecondary),
          onPressed: () => context.pop(),
        ),
        title: Row(
          children: [
            const Text('NamFlix', style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w900)),
            const SizedBox(width: 8),
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
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: AppColors.accentRed))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFeatureTable(),
                  const SizedBox(height: 28),
                  if (_statusMessage != null) ...[
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
                      ),
                      child: Text(_statusMessage!, style: const TextStyle(color: Colors.redAccent, fontSize: 13)),
                    ),
                    const SizedBox(height: 16),
                  ],
                  if (!_storeAvailable) ...[
                    const Center(
                      child: Text(
                        'In-app purchases are not available on this device.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: AppColors.textMuted),
                      ),
                    ),
                  ] else if (_products.isEmpty) ...[
                    const Center(
                      child: Text('Loading subscription options...', style: TextStyle(color: AppColors.textMuted)),
                    ),
                  ] else ...[
                    _buildProductCards(),
                  ],
                  const SizedBox(height: 20),
                  const Center(
                    child: Text(
                      'Subscriptions auto-renew. Cancel any time in your device\'s subscription settings.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppColors.textMuted, fontSize: 11),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildFeatureTable() {
    const rows = [
      ('Live TV Access',  'All channels', 'All channels'),
      ('Advertisements',  'Yes',          'None'),
      ('Favorites',       '20 max',       'Unlimited'),
      ('Watch History',   '7 days',       '90 days'),
      ('HD Priority',     '—',            'Yes'),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Watch More, Worry Less',
          style: TextStyle(color: AppColors.textPrimary, fontSize: 22, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 4),
        const Text('Upgrade to unlock the full NamFlix experience.',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
        const SizedBox(height: 20),
        Row(
          children: const [
            Expanded(flex: 3, child: SizedBox()),
            Expanded(flex: 2, child: Text('Free', textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textMuted, fontSize: 11, fontWeight: FontWeight.w600))),
            Expanded(flex: 2, child: Text('Pro', textAlign: TextAlign.center,
                style: TextStyle(color: Color(0xFFFBBF24), fontSize: 11, fontWeight: FontWeight.w700))),
          ],
        ),
        const SizedBox(height: 8),
        ...rows.map((r) => _FeatureRow(label: r.$1, free: r.$2, pro: r.$3)),
      ],
    );
  }

  Widget _buildProductCards() {
    final monthly = _products.firstWhere(
      (p) => p.id == 'namflix_pro_monthly',
      orElse: () => _products.first,
    );
    final annual = _products.firstWhere(
      (p) => p.id == 'namflix_pro_annual',
      orElse: () => _products.last,
    );

    return Column(
      children: [
        // Annual — highlighted first
        _ProductCard(
          product: annual,
          highlighted: true,
          badge: 'BEST VALUE · SAVE 44%',
          onSubscribe: _purchasing ? null : () => _subscribe(annual),
          loading: _purchasing,
        ),
        const SizedBox(height: 12),
        _ProductCard(
          product: monthly,
          highlighted: false,
          onSubscribe: _purchasing ? null : () => _subscribe(monthly),
          loading: _purchasing,
        ),
      ],
    );
  }
}

// ─── Sub-widgets ─────────────────────────────────────────────────────────────

class _FeatureRow extends StatelessWidget {
  final String label;
  final String free;
  final String pro;

  const _FeatureRow({required this.label, required this.free, required this.pro});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      children: [
        Expanded(flex: 3, child: Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13))),
        Expanded(flex: 2, child: Text(free, textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.textMuted, fontSize: 13, decoration: TextDecoration.lineThrough))),
        Expanded(flex: 2, child: Text(pro, textAlign: TextAlign.center,
            style: const TextStyle(color: Color(0xFF4ADE80), fontSize: 13, fontWeight: FontWeight.w600))),
      ],
    ),
  );
}

class _ProductCard extends StatelessWidget {
  final ProductDetails product;
  final bool highlighted;
  final String? badge;
  final VoidCallback? onSubscribe;
  final bool loading;

  const _ProductCard({
    required this.product,
    required this.highlighted,
    this.badge,
    this.onSubscribe,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            border: Border.all(
              color: highlighted ? const Color(0xFFFBBF24) : AppColors.border,
              width: highlighted ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(16),
            color: highlighted ? Color(0xFFFBBF24).withValues(alpha: 0.06) : AppColors.surface,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (badge != null) const SizedBox(height: 8),
              Text(
                product.id == 'namflix_pro_annual' ? 'Annual' : 'Monthly',
                style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
              ),
              const SizedBox(height: 4),
              Text(product.price,
                style: TextStyle(
                  color: highlighted ? const Color(0xFFFBBF24) : AppColors.textPrimary,
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                )),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 46,
                child: ElevatedButton(
                  onPressed: onSubscribe,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: highlighted ? const Color(0xFFFBBF24) : AppColors.accentRed,
                    foregroundColor: highlighted ? const Color(0xFF78350F) : Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    disabledBackgroundColor: AppColors.border,
                  ),
                  child: loading
                      ? const SizedBox(width: 20, height: 20,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : Text(
                          product.id == 'namflix_pro_annual' ? 'Subscribe Annually' : 'Subscribe Monthly',
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                ),
              ),
            ],
          ),
        ),
        if (badge != null)
          Positioned(
            top: -12,
            left: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFFBBF24),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(badge!, style: const TextStyle(color: Color(0xFF78350F), fontSize: 10, fontWeight: FontWeight.w800)),
            ),
          ),
      ],
    );
  }
}
