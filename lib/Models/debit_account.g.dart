// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'debit_account.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DebitAccountAdapter extends TypeAdapter<DebitAccount> {
  @override
  final int typeId = 3;

  @override
  DebitAccount read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DebitAccount(
      id: fields[0] as String,
      transactions: (fields[2] as List).cast<Transactions>(),
      name: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, DebitAccount obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.transactions);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DebitAccountAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
