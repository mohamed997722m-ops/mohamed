import "dart:ui" as ui;

import 'package:flutter/material.dart';

class ChatRestoreGuideScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('دليل استعادة المحادثات', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.green,
        centerTitle: true,
      ),
      body: Directionality(
        textDirection: ui.TextDirection.rtl,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildIntro(),
              SizedBox(height: 20),
              _buildSection(
                title: '1. واتساب (WhatsApp)',
                icon: Icons.chat,
                content: [
                  'تعتمد استعادة الرسائل في واتساب بشكل أساسي على وجود نسخة احتياطية (Backup).',
                  '\nعلى أندرويد (عبر Google Drive):',
                  '1. تأكد من وجود نسخة احتياطية: اذهب إلى الإعدادات > الدردشات > نسخة احتياطية للدردشات.',
                  '2. الاستعادة:\n   - قم بإلغاء تثبيت واتساب وأعد تثبيته.\n   - افتح التطبيق وأكد رقم هاتفك.\n   - عند المطالبة، اضغط على "استعادة" (Restore) لاسترجاع دردشاتك من Google Drive.',
                  '\nعلى آيفون (عبر iCloud):',
                  '1. تأكد من النسخ الاحتياطي: اذهب إلى إعدادات واتساب > الدردشات > نسخة احتياطية للدردشة.',
                  '2. الاستعادة:\n   - احذف التطبيق وأعد تثبيته من متجر التطبيقات.\n   - أكد رقم هاتفك وحساب iCloud.\n   - اتبع الخطوات للضغط على "استعادة سجل الدردشة".',
                ],
              ),
              _buildSection(
                title: '2. تليجرام (Telegram)',
                icon: Icons.send,
                content: [
                  'تليجرام يحفظ المحادثات سحابياً، لكن إذا حذفت المحادثة نهائياً، فالخيارات محدودة:',
                  '1. ميزة التراجع (Undo): عند حذف محادثة، يظهر شريط أسفل الشاشة لمدة 5 ثوانٍ يتيح لك "تراجع".',
                  '2. تصدير البيانات (عبر نسخة الكمبيوتر):\n   - افتح Telegram Desktop.\n   - اذهب إلى الإعدادات > الإعدادات المتقدمة > تصدير بيانات تليجرام.\n   - قد تجد بعض البيانات المحفوظة هناك.',
                  '3. مجلد التخزين المؤقت (أندرويد): يمكن استخدام مدير ملفات والذهاب إلى Android > data > org.telegram.messenger > cache لمحاولة العثور على الصور أو الملفات المحذوفة.',
                ],
              ),
              _buildSection(
                title: '3. فيسبوك ماسنجر (Facebook Messenger)',
                icon: Icons.chat_bubble,
                content: [
                  '1. التحقق من الأرشيف (Archive): قد تكون المحادثة مخفية وليست محذوفة.\n   - اذهب إلى "الأرشيف" في إعدادات المسنجر وابحث عن المحادثة.',
                  '2. تنزيل معلوماتك:\n   - من تطبيق فيسبوك، اذهب إلى الإعدادات والخصوصية > الإعدادات > مركز الحسابات > معلوماتك وأذوناتك > تنزيل معلوماتك.\n   - اختر "طلب تنزيل"، وحدد "الرسائل" فقط، ثم حدد النطاق الزمني. ستصلك نسخة من الرسائل عبر بريدك الإلكتروني.',
                ],
              ),
              _buildSection(
                title: '4. إنستجرام (Instagram)',
                icon: Icons.camera_alt,
                content: [
                  '1. طلب نسخة من البيانات:\n   - اذهب إلى ملفك الشخصي > الإعدادات والخصوصية > مركز الحسابات > معلوماتك وأذوناتك > تنزيل معلوماتك.\n   - اختر "تنزيل أو نقل المعلومات" وحدد حساب إنستجرام والرسائل.\n   - سيقوم إنستجرام بإرسال ملف يحتوي على جميع محادثاتك (بما فيها بعض المحذوفة حديثاً التي لم تُمحَ من الخوادم بعد).',
                  '2. فحص البريد الإلكتروني: إذا كنت قد فعلت إشعارات الرسائل عبر البريد، فقد تجد محتوى الرسائل هناك.',
                ],
              ),
              _buildNote(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIntro() {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.green.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        'هذا الدليل يشرح كيفية استعادة المحادثات والرسائل في أشهر تطبيقات المراسلة (واتساب، تليجرام، فيسبوك ماسنجر، وإنستجرام).',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _buildSection({required String title, required IconData icon, required List<String> content}) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.green, size: 28),
                SizedBox(width: 10),
                Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green)),
              ],
            ),
            Divider(height: 25),
            ...content.map((text) => Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(text, style: TextStyle(fontSize: 14, height: 1.5)),
            )).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildNote() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.amber.withValues(alpha: 0.1),
        border: Border.all(color: Colors.amber),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, color: Colors.amber[800]),
              SizedBox(width: 8),
              Text('ملاحظة هامة:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.amber[900])),
            ],
          ),
          SizedBox(height: 5),
          Text(
            'يفضل دائماً تفعيل "النسخ الاحتياطي التلقائي" في جميع التطبيقات لتجنب فقدان البيانات مستقبلاً.',
            style: TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }
}
