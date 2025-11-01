part of 'payment_cubit.dart';

abstract class PaymentState {}

class ErrorPaymentState extends PaymentState {
  final String message, messageKey;
  ErrorPaymentState(this.message, this.messageKey);
}

class InitialPaymentState extends PaymentState {}

//PAYMENT METHODS STATE
class LoadingPaymentMethods extends PaymentState {}

class PaymentMethodsLoaded extends PaymentState {
  final List<my_payment_method.PaymentMethod> listPayment;
  PaymentMethodsLoaded(this.listPayment);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PaymentMethodsLoaded &&
        listEquals(other.listPayment, listPayment);
  }

  @override
  int get hashCode => listPayment.hashCode;
}

class PaymentMethodsError extends ErrorPaymentState {
  PaymentMethodsError(super.message, super.messageKey);
}

class ProcessedPaymentState extends PaymentState {
  final PaymentStatus paymentStatus;
  ProcessedPaymentState(this.paymentStatus);
  @override
  String toString() => 'ProcessedPaymentState(paymentStatus: $paymentStatus)';
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ProcessedPaymentState &&
        other.paymentStatus == paymentStatus;
  }

  @override
  int get hashCode => paymentStatus.hashCode;
}

//WALLET DEPOSIT STATES
class LoadingWalletDeposit extends PaymentState {
  LoadingWalletDeposit();
}

class WalletDepositLoaded extends PaymentState {
  final PaymentData paymentData;
  WalletDepositLoaded(this.paymentData);
}

class WalletDepositError extends ErrorPaymentState {
  WalletDepositError(super.message, super.messageKey);
}

//PROCESS PAYMENT STATES
class ProcessingPaymentState extends PaymentState {}

class LoadPaymentUrlState extends PaymentState {
  final String paymentLink;
  final String sUrl;
  final String fUrl;
  LoadPaymentUrlState(this.paymentLink, this.sUrl, this.fUrl);

  @override
  String toString() =>
      'LoadPaymentUrlState(paymentLink: $paymentLink, sUrl: $sUrl, fUrl: $fUrl)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is LoadPaymentUrlState &&
        other.paymentLink == paymentLink &&
        other.sUrl == sUrl &&
        other.fUrl == fUrl;
  }

  @override
  int get hashCode => paymentLink.hashCode ^ sUrl.hashCode ^ fUrl.hashCode;
}
