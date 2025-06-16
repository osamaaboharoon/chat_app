// lib/helpers/chat_helper.dart

/// Generates a unique and consistent chat ID between two users by sorting their emails.
/// This ensures both users access the same chat document regardless of who initiates.
String generateChatId(String a, String b) {
  final sorted = [a, b]..sort();
  return sorted.join('_');
}
