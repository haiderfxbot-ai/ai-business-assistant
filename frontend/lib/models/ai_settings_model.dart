enum AIMode { template, local, cloud }

class AISettingsModel {
  final AIMode primaryMode;
  final AIMode secondaryMode;
  final bool enableAutoReply;
  final bool enableUrduSupport;
  final String aiTone;
  final int maxReplyLength;
  final List<ReplyTemplate> templates;
  final Map<String, String> customPrompts;

  AISettingsModel({
    this.primaryMode = AIMode.local,
    this.secondaryMode = AIMode.cloud,
    this.enableAutoReply = true,
    this.enableUrduSupport = true,
    this.aiTone = 'professional',
    this.maxReplyLength = 500,
    this.templates = const [],
    this.customPrompts = const {},
  });

  factory AISettingsModel.fromMap(Map<String, dynamic> map) {
    return AISettingsModel(
      primaryMode: AIMode.values.firstWhere(
        (e) => e.name == map['primaryMode'],
        orElse: () => AIMode.local,
      ),
      secondaryMode: AIMode.values.firstWhere(
        (e) => e.name == map['secondaryMode'],
        orElse: () => AIMode.cloud,
      ),
      enableAutoReply: map['enableAutoReply'] ?? true,
      enableUrduSupport: map['enableUrduSupport'] ?? true,
      aiTone: map['aiTone'] ?? 'professional',
      maxReplyLength: map['maxReplyLength'] ?? 500,
      templates: (map['templates'] as List?)
              ?.map((e) => ReplyTemplate.fromMap(e))
              .toList() ??
          [],
      customPrompts: Map<String, String>.from(map['customPrompts'] ?? {}),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'primaryMode': primaryMode.name,
      'secondaryMode': secondaryMode.name,
      'enableAutoReply': enableAutoReply,
      'enableUrduSupport': enableUrduSupport,
      'aiTone': aiTone,
      'maxReplyLength': maxReplyLength,
      'templates': templates.map((e) => e.toMap()).toList(),
      'customPrompts': customPrompts,
    };
  }
}

class ReplyTemplate {
  final String id;
  final String triggerKeyword;
  final String replyText;
  final bool isActive;

  ReplyTemplate({
    required this.id,
    required this.triggerKeyword,
    required this.replyText,
    this.isActive = true,
  });

  factory ReplyTemplate.fromMap(Map<String, dynamic> map) {
    return ReplyTemplate(
      id: map['id'] ?? '',
      triggerKeyword: map['triggerKeyword'] ?? '',
      replyText: map['replyText'] ?? '',
      isActive: map['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'triggerKeyword': triggerKeyword,
      'replyText': replyText,
      'isActive': isActive,
    };
  }
}
