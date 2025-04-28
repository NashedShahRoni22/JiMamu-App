// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_rider_data_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UpdateRiderDataModelAdapter extends TypeAdapter<UpdateRiderDataModel> {
  @override
  final int typeId = 5;

  @override
  UpdateRiderDataModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UpdateRiderDataModel(
      success: fields[0] as bool?,
      message: fields[1] as String?,
      data: fields[2] as Data?,
      error: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, UpdateRiderDataModel obj) {
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
      other is UpdateRiderDataModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DataAdapter extends TypeAdapter<Data> {
  @override
  final int typeId = 6;

  @override
  Data read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Data(
      status: fields[0] as String?,
      role: (fields[1] as List?)?.cast<String>(),
      riderDocument: (fields[2] as List?)?.cast<RiderDocument>(),
      riderBankInformation: (fields[3] as List?)?.cast<RiderBankInformation>(),
    );
  }

  @override
  void write(BinaryWriter writer, Data obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.status)
      ..writeByte(1)
      ..write(obj.role)
      ..writeByte(2)
      ..write(obj.riderDocument)
      ..writeByte(3)
      ..write(obj.riderBankInformation);
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

class RiderDocumentAdapter extends TypeAdapter<RiderDocument> {
  @override
  final int typeId = 7;

  @override
  RiderDocument read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RiderDocument(
      documentType: fields[0] as String?,
      documentNumber: fields[1] as String?,
      document: (fields[2] as List?)?.cast<String>(),
      reviewStatus: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, RiderDocument obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.documentType)
      ..writeByte(1)
      ..write(obj.documentNumber)
      ..writeByte(2)
      ..write(obj.document)
      ..writeByte(3)
      ..write(obj.reviewStatus);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RiderDocumentAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class RiderBankInformationAdapter extends TypeAdapter<RiderBankInformation> {
  @override
  final int typeId = 8;

  @override
  RiderBankInformation read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RiderBankInformation(
      id: fields[0] as int?,
      name: fields[1] as String?,
      accountNumber: fields[2] as String?,
      cvcCode: fields[3] as String?,
      expiryDate: fields[4] as String?,
      isDefaultPayment: fields[5] as int?,
      reviewStatus: fields[6] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, RiderBankInformation obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.accountNumber)
      ..writeByte(3)
      ..write(obj.cvcCode)
      ..writeByte(4)
      ..write(obj.expiryDate)
      ..writeByte(5)
      ..write(obj.isDefaultPayment)
      ..writeByte(6)
      ..write(obj.reviewStatus);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RiderBankInformationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
