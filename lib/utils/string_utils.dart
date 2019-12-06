final Map<String, String> asciiMap = {
  'á': 'a',
  'à': 'a',
  'ả': 'a',
  'ã': 'a',
  'ạ': 'a',
  'ă': 'a',
  'ắ': 'a',
  'ằ': 'a',
  'ẳ': 'a',
  'ẵ': 'a',
  'ặ': 'a',
  'â': 'a',
  'ấ': 'a',
  'ầ': 'a',
  'ẩ': 'a',
  'ẫ': 'a',
  'ậ': 'a',
  'đ': 'd',
  'é': 'e',
  'è': 'e',
  'ẻ': 'e',
  'ẽ': 'e',
  'ẹ': 'e',
  'ê': 'e',
  'ế': 'e',
  'ề': 'e',
  'ể': 'e',
  'ễ': 'e',
  'ệ': 'e',
  'í': 'i',
  'ì': 'i',
  'ỉ': 'i',
  'ĩ': 'i',
  'ị': 'i',
  'ó': 'o',
  'ò': 'o',
  'ỏ': 'o',
  'õ': 'o',
  'ọ': 'o',
  'ơ': 'o',
  'ớ': 'o',
  'ờ': 'o',
  'ở': 'o',
  'ỡ': 'o',
  'ợ': 'o',
  'ô': 'o',
  'ố': 'o',
  'ồ': 'o',
  'ổ': 'o',
  'ỗ': 'o',
  'ộ': 'o',
  'ú': 'u',
  'ù': 'u',
  'ủ': 'u',
  'ũ': 'u',
  'ụ': 'u',
  'ư': 'u',
  'ứ': 'u',
  'ừ': 'u',
  'ử': 'u',
  'ữ': 'u',
  'ự': 'u',
};

String convertUnicodeToAsciiText(String text) {
  if (text == null || text.isEmpty) return text;

  String asciiText = '';
  text.toLowerCase().runes.forEach((int rune) {
    var character = new String.fromCharCode(rune);
    asciiText += asciiMap[character] ?? character;
  });
  print('convertUnicodeToAsciiText: $text => $asciiText');
  return asciiText;
}
