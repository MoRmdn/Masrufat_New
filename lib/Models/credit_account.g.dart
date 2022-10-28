// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'credit_account.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CreditAccountAdapter extends TypeAdapter<CreditAccount> {
  @override
  final int typeId = 1;

  @override
  CreditAccount read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CreditAccount(
      transactions: (fields[3] as List).cast<Transactions>(),
      id: fields[0] as String,
      name: fields[1] as String,
      description: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, CreditAccount obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.transactions);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CreditAccountAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
