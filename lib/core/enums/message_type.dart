enum MessageType {
  text,
  image,
  video,
  system;

  static String typeToString(MessageType type) {
    switch (type) {
      case MessageType.text:
        return 'text';
      case MessageType.image:
        return 'image';
      case MessageType.video:
        return 'video';
      case MessageType.system:
        return 'system';
      default:
        return 'text';
    }
  }

  static MessageType fromString(String value) {
    switch (value) {
      case 'text':
        return MessageType.text;
      case 'image':
        return MessageType.image;
      case 'video':
        return MessageType.video;
      case 'system':
        return MessageType.system;
      default:
        return MessageType.text;
    }
  }
}
