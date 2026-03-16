import 'dart:math';

class AttendanceMessages {
  static const List<String> positive = [
    "عاش يا بطل، استمر في السعي، النجاح بانتظارك!",
    "إنجاز رائع! المحاضرة دي خطوة مهمة لمستقبلك.",
    "الله ينور عليك، الالتزام هو مفتاح العظمة.",
    "جدع يا وحش، التعليم هو أقوى سلاح تقدر تغير بيه حياتك.",
    "فخورين بيك، خليك دايماً في المقدمة."
  ];

  static const List<String> motivational = [
    "ركز يا بطل، مستقبلك يستاهل إنك تتعب عشانه.",
    "ولا يهمك، بس افتكر إنك لازم تنجح عشان تكون فخر لنفسك ولأهلك.",
    "خليك فاكر إن التعب النهاردة هو راحة بكرة، شد حيلك!",
    "النجاح مش بييجي بالصدفة، بييجي بالالتزام، حاول تعوضها الجاي.",
    "أنت تقدر تكون أحسن، ابدأ من دلوقتي وحافظ على محاضراتك."
  ];

  static String getPositive() => positive[Random().nextInt(positive.length)];
  static String getMotivational() => motivational[Random().nextInt(motivational.length)];
}
