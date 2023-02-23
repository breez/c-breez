class InputState {
  final dynamic inputType;
  final dynamic inputData;
  final bool isLoading;

  InputState({this.inputType, this.inputData, this.isLoading = false});

  @override
  String toString() => 'InputState{protocol: $inputType, inputData: $inputData, isLoading: $isLoading}';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InputState &&
          runtimeType == other.runtimeType &&
          inputType == other.inputType &&
          inputData == other.inputData &&
          isLoading == other.isLoading;

  @override
  int get hashCode => inputType.hashCode ^ inputData.hashCode ^ isLoading.hashCode;
}
