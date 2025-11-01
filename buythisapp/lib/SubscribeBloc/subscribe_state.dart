class SubscribeState {
  final bool isEmailValid;
  final bool isSubmitting;
  final bool isSuccess;
  final bool isFailure;

  SubscribeState({
    required this.isEmailValid,
    required this.isSubmitting,
    required this.isSuccess,
    required this.isFailure,
  });

  factory SubscribeState.empty() {
    return SubscribeState(
      isEmailValid: true,
      isSubmitting: false,
      isSuccess: false,
      isFailure: false,
    );
  }

  factory SubscribeState.loading() {
    return SubscribeState(
      isEmailValid: true,
      isSubmitting: true,
      isSuccess: false,
      isFailure: false,
    );
  }

  factory SubscribeState.success() {
    return SubscribeState(
      isEmailValid: true,
      isSubmitting: false,
      isSuccess: true,
      isFailure: false,
    );
  }

  factory SubscribeState.failure({
    required bool isEmailValid,
    required bool isFailure,
  }) {
    return SubscribeState(
      isEmailValid: isEmailValid,
      isSubmitting: false,
      isSuccess: false,
      isFailure: isFailure,
    );
  }

  SubscribeState update({
    bool? isEmailValid,
  }) {
    return copyWith(
      isEmailValid: isEmailValid,
      isSubmitting: false,
      isSuccess: false,
      isFailure: false,
    );
  }

  SubscribeState copyWith({
    bool? isEmailValid,
    bool? isSubmitting,
    bool? isSuccess,
    bool? isFailure,
  }) {
    return SubscribeState(
      isEmailValid: isEmailValid ?? this.isEmailValid,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      isFailure: isFailure ?? this.isFailure,
    );
  }

  @override
  String toString() {
    return 'SubscribeState{isEmailValid: $isEmailValid, isSubmitting: $isSubmitting, isSuccess: $isSuccess, isFailure: $isFailure}';
  }
}
