import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class ChatRestoreGuideScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('دليل استعادة المحادثات'),
      ),
      body: Directionality(
        textDirection: ui.TextDirection.rtl,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'دليل استعادة المحادثات القديمة والمحذوفة',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
              ),
              SizedBox(height: 10),
              Text(
                'هذا الدليل يشرح كيفية استعادة المحادثات والرسائل في أشهر تطبيقات المراسلة.',
                style: TextStyle(fontSize: 16),
              ),
              Divider(height: 30),
              _buildSection(
                '1. واتساب (WhatsApp)',
                'تعتمد استعادة الرسائل في واتساب بشكل أساسي على وجود نسخة احتياطية (Backup).',
                [
                  'على أندرويد (عبر Google Drive):',
                  '1. تأكد من وجود نسخة احتياطية: اذهب إلى الإعدادات > الدردشات > نسخة احتياطية للدردشات.',
                  '2. الاستعادة: قم بإلغاء تثبيت واتساب وأعد تثبيته، ثم اضغط على "استعادة" (Restore).',
                  '',
                  'على آيفون (عبر iCloud):',
                  '1. تأكد من النسخ الاحتياطي من إعدادات واتساب > الدردشات > نسخة احتياطية للدردشة.',
                  '2. الاستعادة: احذف التطبيق وأعد تثبيته، ثم اضغط على "استعادة سجل الدردشة".',
                ],
              ),
              _buildSection(
                '2. تليجرام (Telegram)',
                'تليجرام يحفظ المحادثات سحابياً، لكن إذا حذفت المحادثة نهائياً، فالخيارات محدودة:',
                [
                  '1. ميزة التراجع (Undo): عند حذف محادثة، يظهر شريط أسفل الشاشة لمدة 5 ثوانٍ يتيح لك "تراجع".',
                  '2. تصدير البيانات (عبر نسخة الكمبيوتر): اذهب إلى الإعدادات > الإعدادات المتقدمة > تصدير بيانات تليجرام.',
                  '3. مجلد التخزين المؤقت (أندرويد): Android > data > org.telegram.messenger > cache.',
                ],
              ),
              _buildSection(
                '3. فيسبوك ماسنجر (Facebook Messenger)',
                '',
                [
                  '1. التحقق من الأرشيف (Archive): قد تكون المحادثة مخفية وليست محذوفة.',
                  '2. تنزيل معلوماتك: من تطبيق فيسبوك، اذهب إلى الإعدادات > معلوماتك وأذوناتك > تنزيل معلوماتك.',
                ],
              ),
              _buildSection(
                '4. إنستجرام (Instagram)',
                '',
                [
                  '1. طلب نسخة من البيانات: اذهب إلى الإعدادات > مركز الحسابات > معلوماتك وأذوناتك > تنزيل معلوماتك.',
                  '2. فحص البريد الإلكتروني: إذا كنت قد فعلت إشعارات الرسائل، فقد تجد المحتوى هناك.',
                ],
              ),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.amber.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.amber),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.amber[800]),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'ملاحظة هامة: يفضل دائماً تفعيل "النسخ الاحتياطي التلقائي" لتجنب فقدان البيانات.',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, String description, List<String> steps) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green)),
        if (description.isNotEmpty) Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(description),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: steps.map((step) => Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Text(step, style: TextStyle(fontSize: 14)),
            )).toList(),
          ),
        ),
        Divider(),
      ],
    );
  }
}
