import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const NeonSocialApp());
}

class NeonSocialApp extends StatelessWidget {
  const NeonSocialApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Neon Social',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('ar', 'SA')],
      locale: const Locale('ar', 'SA'),
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0D061A),
        textTheme: GoogleFonts.tajawalTextTheme(ThemeData.dark().textTheme),
      ),
      home: const LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  void _login() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MainHomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(-0.8, -0.7),
            radius: 1.2,
            colors: [
              Color(0xFF88147E),
              Color(0xFF13082B),
              Color(0xFF090414),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 26.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 60),
                _buildLogo(),
                const SizedBox(height: 35),
                const Text(
                  'مرحباً بك مجدداً',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'سجل الدخول للمتابعة',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 45),
                _buildCustomTextField(
                  controller: _emailController,
                  hint: 'البريد الإلكتروني',
                  icon: Icons.mail_outline_rounded,
                ),
                const SizedBox(height: 18),
                _buildCustomTextField(
                  controller: _passwordController,
                  hint: 'كلمة المرور',
                  icon: _obscurePassword
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  isPassword: true,
                  onIconPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
                const SizedBox(height: 30),
                Container(
                  width: double.infinity,
                  height: 56,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFF2A6D), Color(0xFFFF4F8B)],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFFF2A6D).withOpacity(0.4),
                        blurRadius: 18,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'تسجيل الدخول',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 35),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'ليس لديك حساب؟ ',
                      style: TextStyle(color: Colors.white.withOpacity(0.7)),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: const Text(
                        'أنشئ حساباً جديداً',
                        style: TextStyle(
                          color: Color(0xFFFF3377),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 90,
      height: 90,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFF3881), Color(0xFF8824D6)],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF3881).withOpacity(0.35),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: const Center(
        child: Icon(Icons.bolt_rounded, size: 55, color: Colors.white),
      ),
    );
  }

  Widget _buildCustomTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    VoidCallback? onIconPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E1438).withOpacity(0.8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF3B2868).withOpacity(0.8),
          width: 1.2,
        ),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword && _obscurePassword,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.white.withOpacity(0.4)),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          suffixIcon: IconButton(
            icon: Icon(icon, color: Colors.white.withOpacity(0.6)),
            onPressed: onIconPressed,
          ),
        ),
      ),
    );
  }
}

class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({super.key});

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    ChatsTab(),
    Center(child: Text("صفحة القصص والأخبار")),
    Center(child: Text("صفحة الفيديوهات القصيرة (Reels)")),
    Center(child: Text("الملف الشخصي")),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _pages[_currentIndex],
          Positioned(
            left: 20,
            right: 20,
            bottom: 25,
            child: Container(
              height: 72,
              decoration: BoxDecoration(
                color: const Color(0xFF1E1435).withOpacity(0.92),
                borderRadius: BorderRadius.circular(35),
                border: Border.all(
                  color: Colors.white.withOpacity(0.12),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.4),
                    blurRadius: 25,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _navItem(0, Icons.chat_bubble_rounded, 'المحادثات'),
                  _navItem(1, Icons.auto_awesome_rounded, 'القصص'),
                  _navItem(2, Icons.play_circle_fill_rounded, 'الفيديوهات'),
                  _navItem(3, Icons.person_rounded, 'الملف'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _navItem(int index, IconData icon, String title) {
    bool isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFFFF2A6D) : Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: isSelected ? Colors.white : Colors.white.withOpacity(0.5),
              size: 22,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            title,
            style: TextStyle(
              fontSize: 11,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? Colors.white : Colors.white.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }
}

class ChatsTab extends StatefulWidget {
  const ChatsTab({super.key});

  @override
  State<ChatsTab> createState() => _ChatsTabState();
}

class _ChatsTabState extends State<ChatsTab> {
  final List> _chats = [
    {
      'name': 'أحمد السعدي',
      'message': 'هل نلتقي اليوم لمناقشة المشروع؟',
      'time': '10:30 ص',
      'unread': 3,
      'isOnline': true,
      'avatar': 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=150',
    },
    {
      'name': 'سارة محمد',
      'message': 'تم إرسال الملفات كما طلبت.',
      'time': '9:15 ص',
      'unread': 2,
      'isOnline': true,
      'avatar': 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150',
    },
    {
      'name': 'محمود خالد',
      'message': 'شكراً لك على التحديث، رائع!',
      'time': 'أمس',
      'unread': 1,
      'isOnline': false,
      'avatar': 'https://images.unsplash.com/photo-1570295999919-56ceb5ecca61?w=150',
    },
    {
      'name': 'نور الهدى',
      'message': 'دعنا نحدد الوقت المناسب.',
      'time': 'أمس',
      'unread': 2,
      'isOnline': false,
      'avatar': 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=150',
    },
    {
      'name': 'يوسف الطائي',
      'message': 'تم استلام الرسالة، شكراً!',
      'time': 'الإثنين',
      'unread': 1,
      'isOnline': false,
      'avatar': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const SizedBox(height: 15),
            const Text(
              'المحادثات',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFF1B1133),
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: Colors.white.withOpacity(0.08)),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Icon(Icons.search_rounded,
                        color: Colors.white.withOpacity(0.4)),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'بحث عن محادثة أو اسم',
                          hintStyle: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.4),
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 15),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 5, 16, 120),
                itemCount: _chats.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final chat = _chats[index];
                  return _buildChatItem(chat);
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 85),
        child: FloatingActionButton(
          onPressed: () {},
          backgroundColor: const Color(0xFFFF2A6D),
          elevation: 10,
          shape: const CircleBorder(),
          child: const Icon(Icons.add, size: 32, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildChatItem(Map<String, dynamic> chat) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF140D26).withOpacity(0.7),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundImage: NetworkImage(chat['avatar']),
              ),
              if (chat['isOnline'])
                Positioned(
                  bottom: 2,
                  right: 2,
                  child: Container(
                    width: 13,
                    height: 13,
                    decoration: BoxDecoration(
                      color: const Color(0xFF00E676),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFF0D061A),
                        width: 2.2,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  chat['name'],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  chat['message'],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                chat['time'],
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withOpacity(0.5),
                ),
              ),
              const SizedBox(height: 8),
              if (chat['unread'] > 0)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: const BoxDecoration(
                    color: Color(0xFFFF2A6D),
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '${chat['unread']}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
