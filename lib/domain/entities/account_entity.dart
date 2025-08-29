import 'package:json_annotation/json_annotation.dart';

part 'account_entity.g.dart';

@JsonSerializable(anyMap: true)
class AccountEntity {
  @JsonKey(name: 'accessToken')
  final String token;

  AccountEntity(this.token);

  factory AccountEntity.fromJson(Map json) => _$AccountEntityFromJson(json);

  Map<String, dynamic> toJson() => _$AccountEntityToJson(this);
}
