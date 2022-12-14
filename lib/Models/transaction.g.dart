// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TransactionsAdapter extends TypeAdapter<Transactions> {
  @override
  final int typeId = 3;

  @override
  Transactions read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Transactions(
      id: fields[0] as String,
      name: fields[2] as String,
      description: fields[4] as String,
      isIncome: fields[3] as bool,
      balance: fields[1] as double,
      transferTo: fields[5] as Account?,
      transferFrom: fields[6] as Account?,
      fromTo: fields[7] as AccountTransferData?,
    );
  }

  @override
  void write(BinaryWriter writer, Transactions obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.balance)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.isIncome)
      ..writeByte(4)
      ..write(obj.description)
      ..writeByte(5)
      ..write(obj.transferTo)
      ..writeByte(6)
      ..write(obj.transferFrom)
      ..writeByte(7)
      ..write(obj.fromTo);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransactionsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
