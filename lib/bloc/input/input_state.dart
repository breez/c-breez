class InputState {
  final dynamic inputData;
  final bool isLoading;

  InputState({this.inputData, this.isLoading = false});

  @override
  String toString() => 'InputState{inputData: $inputData, isLoading: $isLoading}';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InputState &&
          runtimeType == other.runtimeType &&
          inputData == other.inputData &&
          isLoading == other.isLoading;

  @override
  int get hashCode => inputData.hashCode ^ isLoading.hashCode;
}
