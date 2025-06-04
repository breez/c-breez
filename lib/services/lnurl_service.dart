import 'dart:async';

import 'package:breez_sdk/breez_sdk.dart';
import 'package:breez_sdk/sdk.dart';
import 'package:logging/logging.dart';

/// Logger for LnUrlService
final Logger _logger = Logger('LnUrlService');

/// A service for handling LNURL operations through Breez SDK Liquid
///
/// This service provides methods to interact with Lightning Network URL (LNURL)
/// functionality, including withdrawals, payments, and authentication.
class LnUrlService {
  /// Internal SDK reference for Breez Liquid operations
  final BreezSDK _breezSdk;

  /// Creates a new LnUrlService with the required BreezSDKLiquid instance
  ///
  /// [_breezSdkLiquid] The SDK instance to use for LNURL operations
  LnUrlService(this._breezSdk);

  /// Process an LNURL withdraw request
  ///
  /// [req] The withdraw request parameters
  ///
  /// Returns a [LnUrlWithdrawResult] with the withdrawal operation result
  /// Throws an exception if the operation fails
  Future<LnUrlWithdrawResult> lnurlWithdraw({required LnUrlWithdrawRequest req}) async {
    _logger.info('Initiating LNURL withdraw');

    try {
      final LnUrlWithdrawResult result = await _breezSdk.lnurlWithdraw(req: req);

      _logger.info('LNURL withdraw completed successfully');
      return result;
    } catch (e) {
      _logError('lnurlWithdraw', e);
      rethrow;
    }
  }

  /// Execute an LNURL pay request
  ///
  /// [req] The payment request parameters
  ///
  /// Returns a [LnUrlPayResult] with the payment result
  /// Throws an exception if the payment fails
  Future<LnUrlPayResult> lnurlPay({required LnUrlPayRequest req}) async {
    _logger.info('Executing LNURL payment');

    try {
      final LnUrlPayResult result = await _breezSdk.lnurlPay(req: req);

      _logger.info('LNURL payment executed successfully');
      return result;
    } catch (e) {
      _logError('lnurlPay', e);
      rethrow;
    }
  }

  /// Authenticate using LNURL auth
  ///
  /// [reqData] The authentication request data
  ///
  /// Returns a [LnUrlCallbackStatus] indicating the auth operation result
  /// Throws an exception if authentication fails
  Future<LnUrlCallbackStatus> lnurlAuth({required LnUrlAuthRequestData reqData}) async {
    _logger.info('Authenticating with LNURL');

    try {
      final LnUrlCallbackStatus status = await _breezSdk.lnurlAuth(reqData: reqData);

      _logger.info('LNURL authentication completed');
      return status;
    } catch (e) {
      _logError('lnurlAuth', e);
      rethrow;
    }
  }

  /// Log error with consistent format
  ///
  /// [operation] The name of the operation that failed
  /// [error] The error that occurred
  void _logError(String operation, Object error) {
    _logger.severe('$operation error', error);
  }
}
