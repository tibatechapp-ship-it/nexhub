/// يوحّد النص العربي للبحث: يحذف التشكيل، يوحّد الألف والياء والتاء المربوطة.
String normalizeForSearch(String input) {
  var s = input.toLowerCase().trim();
  s = s.replaceAll(RegExp(r'[\u064B-\u065F\u0670]'), '');
  s = s.replaceAll(RegExp(r'[أإآا]'), 'ا');
  s = s.replaceAll('ى', 'ي');
  s = s.replaceAll('ة', 'ه');
  s = s.replaceAll('ؤ', 'و');
  s = s.replaceAll('ئ', 'ي');
  return s;
}

bool arabicContains(String haystack, String needle) =>
    normalizeForSearch(haystack).contains(normalizeForSearch(needle));