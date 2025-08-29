import 'package:curso_com_bloc/domain/entities/entities.dart';
import 'package:json_annotation/json_annotation.dart';

part 'remote_account_model.g.dart';

@JsonSerializable(anyMap: true)
class RemoteAccountModel {
  @JsonKey(name: 'accessToken')
  final String accessToken;

  RemoteAccountModel({
    required this.accessToken,
  });

  AccountEntity toEntity() => AccountEntity(accessToken);

  factory RemoteAccountModel.fromJson(Map json) =>
      _$RemoteAccountModelFromJson(json);

  Map<String, dynamic> toJson() => _$RemoteAccountModelToJson(this);
}
