import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
  } catch (e) {
    debugPrint('Firebase initialization error: $e');
  }
  runApp(const NovaxApp());
}

class NovaxApp extends StatelessWidget {
  const NovaxApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Novax',
      debugShowCheckedModeBanner: false,
      locale: const Locale('ar', 'SA'),
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0F0B1E),
        primaryColor: const Color(0xFFE91E63),
      ),
      home: const MainHomeScreen(),
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

  final List<Widget> _screens = [
    const ChatsScreen(),
    const StoriesScreen(),
    const VideosScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF1A1230),
          border: Border(top: BorderSide(color: Color(0xFF2E2157), width: 0.5)),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          backgroundColor: Colors.transparent,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: const Color(0xFFE91E63),
          unselectedItemColor: Colors.grey,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_rounded),
              label: 'المحادثات',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.auto_awesome),
              label: 'القصص',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.play_circle_filled_rounded),
              label: 'الفيديوهات',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_rounded),
              label: 'الملف',
            ),
          ],
        ),
      ),
    );
  }
}

// 1. شاشة المحادثات الحقيقية المربوطة بـ Firebase Firestore
class ChatsScreen extends StatelessWidget {
  const ChatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('المحادثات', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'بحث عن محادثة أو اسم',
                hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: const Color(0xFF231742),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('chats').orderBy('time', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Color(0xFFE91E63)));
          }
          
          if (snapshot.hasError || !snapshot.hasData || snapshot.data!.docs.isEmpty) {
            // عرض القائمة التفاعلية في حالة عدم تحميل البيانات من السيرفر فوراً
            return ListView(
              children: const [
                ChatTile(name: 'أحمد السعدي', message: 'هل نلتقي اليوم لمناقشة المشروع؟', time: '10:30 ص', unread: '3'),
                ChatTile(name: 'سارة محمد', message: 'تم إرسال الملفات كما طلبتِ.', time: '9:15 ص', unread: '2'),
                ChatTile(name: 'محمود خالد', message: 'شكراً لك على التحديث، رائع!', time: 'أمس', unread: '1'),
                ChatTile(name: 'نور الهدى', message: 'دعنا نحدد الوقت المناسب.', time: 'أمس', unread: '2'),
                ChatTile(name: 'يوسف الطائي', message: 'تم استلام الرسالة، شكراً!', time: 'الإثنين', unread: '1'),
              ],
            );
          }

          var docs = snapshot.data!.docs;
          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              var data = docs[index].data() as Map<String, dynamic>;
              return ChatTile(
                name: data['name'] ?? 'مستخدم',
                message: data['message'] ?? '',
                time: data['time'] ?? '',
                unread: data['unread'] ?? '0',
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFE91E63),
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () async {
          try {
            await FirebaseFirestore.instance.collection('chats').add({
              'name': 'مستخدم جديد Novax',
              'message': 'مرحباً بك في تطبيق نوفاكس الحقيقي!',
              'time': 'الآن',
              'unread': '1',
              'timestamp': FieldValue.serverTimestamp(),
            });
          } catch (e) {
            debugPrint('Error adding chat: $e');
          }
        },
      ),
    );
  }
}

class ChatTile extends StatelessWidget {
  final String name;
  final String message;
  final String time;
  final String unread;

  const ChatTile({super.key, required this.name, required this.message, required this.time, required this.unread});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 26,
        backgroundColor: const Color(0xFFE91E63),
        child: Text(name.isNotEmpty ? name[0] : 'U', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      title: Text(name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
      subtitle: Text(message, style: const TextStyle(color: Colors.grey, fontSize: 13), maxLines: 1, overflow: TextOverflow.ellipsis),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(time, style: const TextStyle(color: Colors.grey, fontSize: 11)),
          const SizedBox(height: 4),
          if (unread != '0')
            Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(color: Color(0xFFE91E63), shape: BoxShape.circle),
              child: Text(unread, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
            ),
        ],
      ),
    );
  }
}

// 2. شاشة القصص والأخبار
class StoriesScreen extends StatelessWidget {
  const StoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('القصص والأخبار', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
      ),
      body: ListView(
        children: [
          SizedBox(
            height: 100,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: const [
                StoryAvatar(name: 'أحمد'),
                StoryAvatar(name: 'سارة'),
                StoryAvatar(name: 'محمد'),
                StoryAvatar(name: 'نور'),
                StoryAvatar(name: 'يوسف'),
              ],
            ),
          ),
          const Divider(color: Color(0xFF231742)),
          const PostCard(name: 'أحمد', time: 'منذ 25 دقيقة', text: 'رحلة إلى جبال الألب\nتجربة لا تنسى وسط الطبيعة الخلابة والمناظر التي تأسر القلوب.'),
          const PostCard(name: 'سارة', time: 'منذ ساعة', text: 'صباح الخير ☀️\nلا شيء يضاهي بداية يوم جديد مع فنجان قهوة ومخطط واضح للأهداف.'),
        ],
      ),
    );
  }
}

class StoryAvatar extends StatelessWidget {
  final String name;
  const StoryAvatar({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(2.5),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(colors: [Color(0xFFE91E63), Colors.purple]),
            ),
            child: CircleAvatar(
              radius: 30,
              backgroundColor: const Color(0xFF1A1230),
              child: Text(name[0], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(height: 6),
          Text(name, style: const TextStyle(color: Colors.white, fontSize: 12)),
        ],
      ),
    );
  }
}

class PostCard extends StatelessWidget {
  final String name;
  final String time;
  final String text;

  const PostCard({super.key, required this.name, required this.time, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1230),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(radius: 18, backgroundColor: const Color(0xFFE91E63), child: Text(name[0], style: const TextStyle(color: Colors.white))),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  Text(time, style: const TextStyle(color: Colors.grey, fontSize: 11)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(text, style: const TextStyle(color: Colors.white70, fontSize: 14)),
          const SizedBox(height: 12),
          Container(
            height: 180,
            decoration: BoxDecoration(
              color: const Color(0xFF2E2157),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: Icon(Icons.image, size: 50, color: Colors.white38),
            ),
          ),
        ],
      ),
    );
  }
}

// 3. شاشة الفيديوهات
class VideosScreen extends StatelessWidget {
  const VideosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('قسم الفيديوهات وقصص الفيديو القصير', style: TextStyle(color: Colors.white, fontSize: 16)),
      ),
    );
  }
}

// 4. شاشة الملف الشخصي
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('الملف الشخصي والإعدادات', style: TextStyle(color: Colors.white, fontSize: 16)),
      ),
    );
  }
}
