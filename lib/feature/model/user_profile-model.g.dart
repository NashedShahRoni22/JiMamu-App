// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile-model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserProfileDataModelAdapter extends TypeAdapter<UserProfileDataModel> {
  @override
  final int typeId = 3;

  @override
  UserProfileDataModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserProfileDataModel(
      success: fields[0] as bool?,
      message: fields[1] as String?,
      data: fields[2] as Data?,
      error: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, UserProfileDataModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.success)
      ..writeByte(1)
      ..write(obj.message)
      ..writeByte(2)
      ..write(obj.data)
      ..writeByte(3)
      ..write(obj.error);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserProfileDataModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DataAdapter extends TypeAdapter<Data> {
  @override
  final int typeId = 4;

  @override
  Data read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Data(
      id: fields[0] as int?,
      name: fields[1] as String?,
      email: fields[2] as String?,
      phoneNumber: fields[3] as String?,
      emailVerifiedAt: fields[4] as int?,
      profileImage: fields[5] as String?,
      dob: fields[6] as String?,
      gender: fields[7] as String?,
      verificationCode: fields[8] as int?,
      userType: fields[9] as int?,
      status: fields[10] as dynamic,
      createdAt: fields[11] as String?,
      updatedAt: fields[12] as String?,
      deletedAt: fields[13] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, Data obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.email)
      ..writeByte(3)
      ..write(obj.phoneNumber)
      ..writeByte(4)
      ..write(obj.emailVerifiedAt)
      ..writeByte(5)
      ..write(obj.profileImage)
      ..writeByte(6)
      ..write(obj.dob)
      ..writeByte(7)
      ..write(obj.gender)
      ..writeByte(8)
      ..write(obj.verificationCode)
      ..writeByte(9)
      ..write(obj.userType)
      ..writeByte(10)
      ..write(obj.status)
      ..writeByte(11)
      ..write(obj.createdAt)
      ..writeByte(12)
      ..write(obj.updatedAt)
      ..writeByte(13)
      ..write(obj.deletedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
