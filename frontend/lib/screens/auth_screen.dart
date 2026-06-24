import 'dart:io';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:image_picker/image_picker.dart';
import '../theme/app_theme.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isLogin = true;
  bool _isCookRegistration = false;
  File? _profileImage;
  final ImagePicker _picker = ImagePicker();
  
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _fullNameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _executeLogin() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final success = await authProvider.login(
      _emailController.text,
      _passwordController.text,
    );
    if (success && mounted) {
      Navigator.of(context).pushReplacementNamed('/home');
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(authProvider.error ?? 'Login failed')),
      );
    }
  }

  void _executeRegister() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final success = await authProvider.register(
      _fullNameController.text,
      _emailController.text,
      _passwordController.text,
      phone: _phoneController.text.isNotEmpty ? _phoneController.text : null,
      role: _isCookRegistration ? 'COOK' : 'CUSTOMER',
    );
    if (success && mounted) {
      if (_isCookRegistration) {
        Navigator.of(context).pushReplacementNamed('/cook');
      } else {
        Navigator.of(context).pushReplacementNamed('/home');
      }
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(authProvider.error ?? 'Registration failed')),
      );
    }
  }

  Future<void> _pickProfileImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _profileImage = File(image.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // BASE GRADIENT LAYER
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFFF4F9F6), Color(0xFFC2E3D4)],
              ),
            ),
          ),
          
          // THE PATTERN BACKGROUND
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/tiffin_pattern_blank.png'),
                fit: BoxFit.cover,
                opacity: 0.15, // Professional depth transparency
              ),
            ),
          ),
          
          // INTERACTIVE UI
          SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420), // Optimal proportional width
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // NEW CIRCULAR LOGO BADGE
                      Container(
                        height: 140, // Perfectly fitted tight circle
                        width: 140,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 20,
                              offset: Offset(0, 10),
                            ),
                          ],
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Transform.translate(
                          offset: const Offset(0, 8), // Shifts logo down to correct vertical centering
                          child: Transform.scale(
                            scale: 1.35, // Blows the logo up past any internal image padding to fill circle
                            child: Image.asset(
                              'assets/images/tiffin_logo.png',
                              fit: BoxFit.contain, 
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      
                      // BRAND NAME
                      const Text(
                        'Tiffin',
                        style: TextStyle(
                          fontSize: 38, // Slightly dialed back for balance
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF004D26), // Deep dark green
                          letterSpacing: -1.0,
                          fontFamily: 'Outfit',
                        ),
                      ),
                      const SizedBox(height: 4),
                      
                      // NEW TAGLINE
                      const Text(
                        'Taste home. Zero waste.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFFF57C00), // Warm orange
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                          fontFamily: 'Outfit',
                        ),
                      ),
                      const SizedBox(height: 32),

                      // FLOATING AUTH CARD
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(32),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.06), // Diffuse macro shadow
                              blurRadius: 40,
                              offset: const Offset(0, 12),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(32),
                          child: Column(
                            children: [
                              // TABS
                              Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(color: Colors.grey.shade100),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    _buildTab('Sign In', _isLogin, () => setState(() => _isLogin = true)),
                                    _buildTab('Register', !_isLogin, () => setState(() => _isLogin = false)),
                                  ],
                                ),
                              ),

                              // FORM AREA
                              AnimatedSize(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                                child: Padding(
                                  padding: const EdgeInsets.all(28.0),
                                  child: _isLogin ? _buildLoginForm() : _buildRegisterForm(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String text, bool isSelected, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isSelected ? const Color(0xFF00B159) : Colors.transparent,
                width: 3,
              ),
            ),
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isSelected ? FontWeight.w900 : FontWeight.w600,
              color: isSelected ? const Color(0xFF00B159) : AppTheme.textMuted,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginForm() {
    return Column(
      key: const ValueKey('login'),
      children: [
        _buildTextField('Email Address', LucideIcons.mail, controller: _emailController),
        const SizedBox(height: 16),
        _buildTextField('Password', LucideIcons.lock, obscureText: true, controller: _passwordController),
        const SizedBox(height: 32),
        SizedBox(
          width: double.infinity,
          child: Consumer<AuthProvider>(
            builder: (context, auth, _) => ElevatedButton(
              onPressed: auth.isLoading ? null : _executeLogin,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00B159), // Grab Green
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              child: auth.isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text(
                      'Sign In',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
                    ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRegisterForm() {
    return Column(
      key: const ValueKey('register'),
      children: [
        // INTERACTIVE PROFILE PHOTO PICKER
        GestureDetector(
          onTap: _pickProfileImage,
          child: Center(
            child: Stack(
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: AppTheme.backgroundCanvas,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey.shade200, width: 2),
                    image: _profileImage != null
                        ? DecorationImage(
                            image: FileImage(_profileImage!),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: _profileImage == null
                      ? const Icon(LucideIcons.user, size: 40, color: AppTheme.textMuted)
                      : null,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF00B159),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Icon(Icons.add_a_photo, color: Colors.white, size: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 32),

        // ROLE TOGGLE
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: AppTheme.backgroundCanvas,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _isCookRegistration = false),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: !_isCookRegistration ? Colors.white : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: !_isCookRegistration
                          ? [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4)]
                          : [],
                    ),
                    child: Text(
                      'Customer',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        color: !_isCookRegistration ? const Color(0xFF00B159) : AppTheme.textMuted,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _isCookRegistration = true),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: _isCookRegistration ? Colors.white : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: _isCookRegistration
                          ? [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4)]
                          : [],
                    ),
                    child: Text(
                      'Home Cook',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        color: _isCookRegistration ? const Color(0xFF00B159) : AppTheme.textMuted,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        
        _buildTextField('Full Name', LucideIcons.user, controller: _fullNameController),
        const SizedBox(height: 16),
        _buildTextField('Phone Number', LucideIcons.phone, controller: _phoneController),
        const SizedBox(height: 16),
        _buildTextField('Email Address', LucideIcons.mail, controller: _emailController),
        const SizedBox(height: 16),
        _buildTextField('Password', LucideIcons.lock, obscureText: true, controller: _passwordController),
        
        // HOME COOK COMPLIANCE WIZARD
        AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: _isCookRegistration
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 32),
                    const Divider(),
                    const SizedBox(height: 24),
                    const Text(
                      'Compliance Documents',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: AppTheme.textDark,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Tiffin ensures 100% KKM hygiene compliance.',
                      style: TextStyle(fontSize: 13, color: AppTheme.textMuted),
                    ),
                    const SizedBox(height: 20),
                    _buildUploadButton('1. Upload IC/Passport', LucideIcons.fileText),
                    const SizedBox(height: 12),
                    _buildUploadButton('2. Upload SSM Certificate', LucideIcons.building),
                    const SizedBox(height: 12),
                    _buildUploadButton('3. Suntikan Typhoid', LucideIcons.syringe),
                  ],
                )
              : const SizedBox.shrink(),
        ),
        
        const SizedBox(height: 32),
        SizedBox(
          width: double.infinity,
          child: Consumer<AuthProvider>(
            builder: (context, auth, _) => ElevatedButton(
              onPressed: auth.isLoading ? null : _executeRegister,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00B159),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              child: auth.isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : Text(
                      _isCookRegistration ? 'Apply as Home Cook' : 'Create Account',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
                    ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(String label, IconData icon, {bool obscureText = false, TextEditingController? controller}) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      style: const TextStyle(fontWeight: FontWeight.w600, color: AppTheme.textDark),
      decoration: InputDecoration(
        hintText: label,
        hintStyle: const TextStyle(color: AppTheme.textMuted),
        prefixIcon: Icon(icon, color: AppTheme.textMuted, size: 20),
        filled: true,
        fillColor: const Color(0xFFF0F2F5), // Sleek off-white
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none, 
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none, 
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFF00B159), width: 2), // Tech Grab Green active shift
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      ),
    );
  }

  Widget _buildUploadButton(String label, IconData icon) {
    return OutlinedButton.icon(
      onPressed: () {},
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        foregroundColor: AppTheme.textDark,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        side: BorderSide(color: Colors.grey.shade300, width: 1.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.centerLeft,
        minimumSize: const Size(double.infinity, 50),
      ),
    );
  }
}
