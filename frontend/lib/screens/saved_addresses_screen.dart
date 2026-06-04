import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../theme/app_theme.dart';

class SavedAddressesScreen extends StatefulWidget {
  const SavedAddressesScreen({super.key});

  @override
  State<SavedAddressesScreen> createState() => _SavedAddressesScreenState();
}

class _SavedAddressesScreenState extends State<SavedAddressesScreen> {
  final List<Map<String, dynamic>> _addresses = [
    {
      'label': 'Home',
      'icon': LucideIcons.home,
      'line1': 'Unit 12A, Residensi Damansara',
      'line2': 'Jalan Damansara, 50490 Kuala Lumpur',
      'isDefault': true,
    },
    {
      'label': 'Office',
      'icon': LucideIcons.building2,
      'line1': 'Level 18, Menara Shell',
      'line2': 'Jalan Tun Sambanthan, 50470 KL',
      'isDefault': false,
    },
  ];

  void _setDefault(int index) {
    setState(() {
      for (int i = 0; i < _addresses.length; i++) {
        _addresses[i]['isDefault'] = (i == index);
      }
    });
  }

  void _deleteAddress(int index) {
    setState(() {
      _addresses.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Address removed'),
        backgroundColor: AppTheme.textDark,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _showAddAddressSheet({int? editIndex}) {
    final labelController = TextEditingController(
      text: editIndex != null ? _addresses[editIndex]['label'] : '',
    );
    final line1Controller = TextEditingController(
      text: editIndex != null ? _addresses[editIndex]['line1'] : '',
    );
    final line2Controller = TextEditingController(
      text: editIndex != null ? _addresses[editIndex]['line2'] : '',
    );
    IconData selectedIcon =
        editIndex != null ? _addresses[editIndex]['icon'] : LucideIcons.mapPin;

    final iconOptions = [
      {'icon': LucideIcons.home, 'label': 'Home'},
      {'icon': LucideIcons.building2, 'label': 'Office'},
      {'icon': LucideIcons.mapPin, 'label': 'Other'},
      {'icon': LucideIcons.heart, 'label': 'Partner'},
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(ctx).viewInsets.bottom,
              ),
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(28)),
                ),
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      editIndex != null ? 'Edit Address' : 'Add New Address',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: AppTheme.textDark,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Icon picker
                    const Text(
                      'ADDRESS TYPE',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                        color: AppTheme.textMuted,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: iconOptions.map((opt) {
                        final isSelected = selectedIcon == opt['icon'];
                        return Expanded(
                          child: GestureDetector(
                            onTap: () => setModalState(
                                () => selectedIcon = opt['icon'] as IconData),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              margin: const EdgeInsets.only(right: 8),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppTheme.primaryBrand
                                    : Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isSelected
                                      ? AppTheme.primaryBrand
                                      : Colors.transparent,
                                ),
                              ),
                              child: Column(
                                children: [
                                  Icon(
                                    opt['icon'] as IconData,
                                    color: isSelected
                                        ? Colors.white
                                        : AppTheme.textMuted,
                                    size: 20,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    opt['label'] as String,
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: isSelected
                                          ? Colors.white
                                          : AppTheme.textMuted,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),

                    // Label field
                    _buildTextField(
                      controller: labelController,
                      label: 'LABEL (e.g. Home, Mama\'s House)',
                      hint: 'Home',
                    ),
                    const SizedBox(height: 14),
                    _buildTextField(
                      controller: line1Controller,
                      label: 'STREET / UNIT',
                      hint: 'Unit 12A, Taman Desa',
                    ),
                    const SizedBox(height: 14),
                    _buildTextField(
                      controller: line2Controller,
                      label: 'CITY & POSTCODE',
                      hint: '50490 Kuala Lumpur',
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (line1Controller.text.trim().isEmpty) return;
                          setState(() {
                            final newAddr = {
                              'label': labelController.text.trim().isEmpty
                                  ? 'Address'
                                  : labelController.text.trim(),
                              'icon': selectedIcon,
                              'line1': line1Controller.text.trim(),
                              'line2': line2Controller.text.trim(),
                              'isDefault': editIndex != null
                                  ? _addresses[editIndex]['isDefault']
                                  : _addresses.isEmpty,
                            };
                            if (editIndex != null) {
                              _addresses[editIndex] = newAddr;
                            } else {
                              _addresses.add(newAddr);
                            }
                          });
                          Navigator.pop(ctx);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryBrand,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: Text(
                          editIndex != null ? 'Save Changes' : 'Add Address',
                          style: const TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w900,
            color: AppTheme.textMuted,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey.shade400),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            filled: true,
            fillColor: Colors.grey.shade50,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  const BorderSide(color: AppTheme.primaryBrand, width: 2),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundCanvas,
      appBar: AppBar(
        title: const Text('Saved Addresses'),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddAddressSheet(),
        backgroundColor: AppTheme.primaryBrand,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Add Address',
          style: TextStyle(
            fontWeight: FontWeight.w900,
            color: Colors.white,
          ),
        ),
      ),
      body: _addresses.isEmpty
          ? _buildEmptyState()
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
              itemCount: _addresses.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final addr = _addresses[index];
                return _AddressCard(
                  label: addr['label'] as String,
                  icon: addr['icon'] as IconData,
                  line1: addr['line1'] as String,
                  line2: addr['line2'] as String,
                  isDefault: addr['isDefault'] as bool,
                  onSetDefault: () => _setDefault(index),
                  onEdit: () => _showAddAddressSheet(editIndex: index),
                  onDelete: () => _deleteAddress(index),
                );
              },
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: AppTheme.primaryBrand.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              LucideIcons.mapPin,
              size: 48,
              color: AppTheme.primaryBrand,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'No Saved Addresses',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: AppTheme.textDark,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Add your home or office\nfor faster checkout.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppTheme.textMuted, fontSize: 14),
          ),
        ],
      ),
    );
  }
}

class _AddressCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final String line1;
  final String line2;
  final bool isDefault;
  final VoidCallback onSetDefault;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _AddressCard({
    required this.label,
    required this.icon,
    required this.line1,
    required this.line2,
    required this.isDefault,
    required this.onSetDefault,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDefault
              ? AppTheme.primaryBrand.withValues(alpha: 0.5)
              : Colors.grey.shade200,
          width: isDefault ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryBrand.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: AppTheme.primaryBrand, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            label,
                            style: const TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 16,
                              color: AppTheme.textDark,
                            ),
                          ),
                          if (isDefault) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color:
                                    AppTheme.primaryBrand.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text(
                                'Default',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w900,
                                  color: AppTheme.primaryBrand,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        line1,
                        style: const TextStyle(
                            fontSize: 13, color: AppTheme.textDark),
                      ),
                      Text(
                        line2,
                        style: const TextStyle(
                            fontSize: 13, color: AppTheme.textMuted),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            const Divider(height: 1),
            const SizedBox(height: 10),
            Row(
              children: [
                if (!isDefault)
                  _ActionChip(
                    icon: LucideIcons.checkCircle2,
                    label: 'Set Default',
                    onTap: onSetDefault,
                    color: AppTheme.primaryBrand,
                  ),
                if (!isDefault) const SizedBox(width: 8),
                _ActionChip(
                  icon: LucideIcons.pencil,
                  label: 'Edit',
                  onTap: onEdit,
                  color: AppTheme.textMuted,
                ),
                const Spacer(),
                _ActionChip(
                  icon: LucideIcons.trash2,
                  label: 'Delete',
                  onTap: onDelete,
                  color: AppTheme.danger,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color color;

  const _ActionChip({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 5),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
