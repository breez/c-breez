///
//  Generated code. Do not modify.
//  source: greenlight.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

import 'dart:async' as $async;

import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'greenlight.pb.dart' as $0;
export 'greenlight.pb.dart';

class NodeClient extends $grpc.Client {
  static final _$getInfo =
      $grpc.ClientMethod<$0.GetInfoRequest, $0.GetInfoResponse>(
          '/greenlight.Node/GetInfo',
          ($0.GetInfoRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              $0.GetInfoResponse.fromBuffer(value));
  static final _$stop = $grpc.ClientMethod<$0.StopRequest, $0.StopResponse>(
      '/greenlight.Node/Stop',
      ($0.StopRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.StopResponse.fromBuffer(value));
  static final _$connectPeer =
      $grpc.ClientMethod<$0.ConnectRequest, $0.ConnectResponse>(
          '/greenlight.Node/ConnectPeer',
          ($0.ConnectRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              $0.ConnectResponse.fromBuffer(value));
  static final _$listPeers =
      $grpc.ClientMethod<$0.ListPeersRequest, $0.ListPeersResponse>(
          '/greenlight.Node/ListPeers',
          ($0.ListPeersRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              $0.ListPeersResponse.fromBuffer(value));
  static final _$disconnect =
      $grpc.ClientMethod<$0.DisconnectRequest, $0.DisconnectResponse>(
          '/greenlight.Node/Disconnect',
          ($0.DisconnectRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              $0.DisconnectResponse.fromBuffer(value));
  static final _$newAddr =
      $grpc.ClientMethod<$0.NewAddrRequest, $0.NewAddrResponse>(
          '/greenlight.Node/NewAddr',
          ($0.NewAddrRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              $0.NewAddrResponse.fromBuffer(value));
  static final _$listFunds =
      $grpc.ClientMethod<$0.ListFundsRequest, $0.ListFundsResponse>(
          '/greenlight.Node/ListFunds',
          ($0.ListFundsRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              $0.ListFundsResponse.fromBuffer(value));
  static final _$withdraw =
      $grpc.ClientMethod<$0.WithdrawRequest, $0.WithdrawResponse>(
          '/greenlight.Node/Withdraw',
          ($0.WithdrawRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              $0.WithdrawResponse.fromBuffer(value));
  static final _$fundChannel =
      $grpc.ClientMethod<$0.FundChannelRequest, $0.FundChannelResponse>(
          '/greenlight.Node/FundChannel',
          ($0.FundChannelRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              $0.FundChannelResponse.fromBuffer(value));
  static final _$closeChannel =
      $grpc.ClientMethod<$0.CloseChannelRequest, $0.CloseChannelResponse>(
          '/greenlight.Node/CloseChannel',
          ($0.CloseChannelRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              $0.CloseChannelResponse.fromBuffer(value));
  static final _$createInvoice =
      $grpc.ClientMethod<$0.InvoiceRequest, $0.Invoice>(
          '/greenlight.Node/CreateInvoice',
          ($0.InvoiceRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) => $0.Invoice.fromBuffer(value));
  static final _$pay = $grpc.ClientMethod<$0.PayRequest, $0.Payment>(
      '/greenlight.Node/Pay',
      ($0.PayRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.Payment.fromBuffer(value));
  static final _$keysend = $grpc.ClientMethod<$0.KeysendRequest, $0.Payment>(
      '/greenlight.Node/Keysend',
      ($0.KeysendRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.Payment.fromBuffer(value));
  static final _$listPayments =
      $grpc.ClientMethod<$0.ListPaymentsRequest, $0.ListPaymentsResponse>(
          '/greenlight.Node/ListPayments',
          ($0.ListPaymentsRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              $0.ListPaymentsResponse.fromBuffer(value));
  static final _$listInvoices =
      $grpc.ClientMethod<$0.ListInvoicesRequest, $0.ListInvoicesResponse>(
          '/greenlight.Node/ListInvoices',
          ($0.ListInvoicesRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              $0.ListInvoicesResponse.fromBuffer(value));
  static final _$streamIncoming =
      $grpc.ClientMethod<$0.StreamIncomingFilter, $0.IncomingPayment>(
          '/greenlight.Node/StreamIncoming',
          ($0.StreamIncomingFilter value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              $0.IncomingPayment.fromBuffer(value));
  static final _$streamLog =
      $grpc.ClientMethod<$0.StreamLogRequest, $0.LogEntry>(
          '/greenlight.Node/StreamLog',
          ($0.StreamLogRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) => $0.LogEntry.fromBuffer(value));
  static final _$streamHsmRequests =
      $grpc.ClientMethod<$0.Empty, $0.HsmRequest>(
          '/greenlight.Node/StreamHsmRequests',
          ($0.Empty value) => value.writeToBuffer(),
          ($core.List<$core.int> value) => $0.HsmRequest.fromBuffer(value));
  static final _$respondHsmRequest =
      $grpc.ClientMethod<$0.HsmResponse, $0.Empty>(
          '/greenlight.Node/RespondHsmRequest',
          ($0.HsmResponse value) => value.writeToBuffer(),
          ($core.List<$core.int> value) => $0.Empty.fromBuffer(value));

  NodeClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options, interceptors: interceptors);

  $grpc.ResponseFuture<$0.GetInfoResponse> getInfo($0.GetInfoRequest request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$getInfo, request, options: options);
  }

  $grpc.ResponseFuture<$0.StopResponse> stop($0.StopRequest request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$stop, request, options: options);
  }

  $grpc.ResponseFuture<$0.ConnectResponse> connectPeer(
      $0.ConnectRequest request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$connectPeer, request, options: options);
  }

  $grpc.ResponseFuture<$0.ListPeersResponse> listPeers(
      $0.ListPeersRequest request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$listPeers, request, options: options);
  }

  $grpc.ResponseFuture<$0.DisconnectResponse> disconnect(
      $0.DisconnectRequest request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$disconnect, request, options: options);
  }

  $grpc.ResponseFuture<$0.NewAddrResponse> newAddr($0.NewAddrRequest request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$newAddr, request, options: options);
  }

  $grpc.ResponseFuture<$0.ListFundsResponse> listFunds(
      $0.ListFundsRequest request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$listFunds, request, options: options);
  }

  $grpc.ResponseFuture<$0.WithdrawResponse> withdraw($0.WithdrawRequest request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$withdraw, request, options: options);
  }

  $grpc.ResponseFuture<$0.FundChannelResponse> fundChannel(
      $0.FundChannelRequest request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$fundChannel, request, options: options);
  }

  $grpc.ResponseFuture<$0.CloseChannelResponse> closeChannel(
      $0.CloseChannelRequest request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$closeChannel, request, options: options);
  }

  $grpc.ResponseFuture<$0.Invoice> createInvoice($0.InvoiceRequest request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$createInvoice, request, options: options);
  }

  $grpc.ResponseFuture<$0.Payment> pay($0.PayRequest request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$pay, request, options: options);
  }

  $grpc.ResponseFuture<$0.Payment> keysend($0.KeysendRequest request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$keysend, request, options: options);
  }

  $grpc.ResponseFuture<$0.ListPaymentsResponse> listPayments(
      $0.ListPaymentsRequest request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$listPayments, request, options: options);
  }

  $grpc.ResponseFuture<$0.ListInvoicesResponse> listInvoices(
      $0.ListInvoicesRequest request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$listInvoices, request, options: options);
  }

  $grpc.ResponseStream<$0.IncomingPayment> streamIncoming(
      $0.StreamIncomingFilter request,
      {$grpc.CallOptions? options}) {
    return $createStreamingCall(
        _$streamIncoming, $async.Stream.fromIterable([request]),
        options: options);
  }

  $grpc.ResponseStream<$0.LogEntry> streamLog($0.StreamLogRequest request,
      {$grpc.CallOptions? options}) {
    return $createStreamingCall(
        _$streamLog, $async.Stream.fromIterable([request]),
        options: options);
  }

  $grpc.ResponseStream<$0.HsmRequest> streamHsmRequests($0.Empty request,
      {$grpc.CallOptions? options}) {
    return $createStreamingCall(
        _$streamHsmRequests, $async.Stream.fromIterable([request]),
        options: options);
  }

  $grpc.ResponseFuture<$0.Empty> respondHsmRequest($0.HsmResponse request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$respondHsmRequest, request, options: options);
  }
}

abstract class NodeServiceBase extends $grpc.Service {
  $core.String get $name => 'greenlight.Node';

  NodeServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.GetInfoRequest, $0.GetInfoResponse>(
        'GetInfo',
        getInfo_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.GetInfoRequest.fromBuffer(value),
        ($0.GetInfoResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.StopRequest, $0.StopResponse>(
        'Stop',
        stop_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.StopRequest.fromBuffer(value),
        ($0.StopResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ConnectRequest, $0.ConnectResponse>(
        'ConnectPeer',
        connectPeer_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.ConnectRequest.fromBuffer(value),
        ($0.ConnectResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ListPeersRequest, $0.ListPeersResponse>(
        'ListPeers',
        listPeers_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.ListPeersRequest.fromBuffer(value),
        ($0.ListPeersResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.DisconnectRequest, $0.DisconnectResponse>(
        'Disconnect',
        disconnect_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.DisconnectRequest.fromBuffer(value),
        ($0.DisconnectResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.NewAddrRequest, $0.NewAddrResponse>(
        'NewAddr',
        newAddr_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.NewAddrRequest.fromBuffer(value),
        ($0.NewAddrResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ListFundsRequest, $0.ListFundsResponse>(
        'ListFunds',
        listFunds_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.ListFundsRequest.fromBuffer(value),
        ($0.ListFundsResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.WithdrawRequest, $0.WithdrawResponse>(
        'Withdraw',
        withdraw_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.WithdrawRequest.fromBuffer(value),
        ($0.WithdrawResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.FundChannelRequest, $0.FundChannelResponse>(
            'FundChannel',
            fundChannel_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.FundChannelRequest.fromBuffer(value),
            ($0.FundChannelResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.CloseChannelRequest, $0.CloseChannelResponse>(
            'CloseChannel',
            closeChannel_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.CloseChannelRequest.fromBuffer(value),
            ($0.CloseChannelResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.InvoiceRequest, $0.Invoice>(
        'CreateInvoice',
        createInvoice_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.InvoiceRequest.fromBuffer(value),
        ($0.Invoice value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.PayRequest, $0.Payment>(
        'Pay',
        pay_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.PayRequest.fromBuffer(value),
        ($0.Payment value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.KeysendRequest, $0.Payment>(
        'Keysend',
        keysend_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.KeysendRequest.fromBuffer(value),
        ($0.Payment value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.ListPaymentsRequest, $0.ListPaymentsResponse>(
            'ListPayments',
            listPayments_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.ListPaymentsRequest.fromBuffer(value),
            ($0.ListPaymentsResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.ListInvoicesRequest, $0.ListInvoicesResponse>(
            'ListInvoices',
            listInvoices_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.ListInvoicesRequest.fromBuffer(value),
            ($0.ListInvoicesResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.StreamIncomingFilter, $0.IncomingPayment>(
        'StreamIncoming',
        streamIncoming_Pre,
        false,
        true,
        ($core.List<$core.int> value) =>
            $0.StreamIncomingFilter.fromBuffer(value),
        ($0.IncomingPayment value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.StreamLogRequest, $0.LogEntry>(
        'StreamLog',
        streamLog_Pre,
        false,
        true,
        ($core.List<$core.int> value) => $0.StreamLogRequest.fromBuffer(value),
        ($0.LogEntry value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Empty, $0.HsmRequest>(
        'StreamHsmRequests',
        streamHsmRequests_Pre,
        false,
        true,
        ($core.List<$core.int> value) => $0.Empty.fromBuffer(value),
        ($0.HsmRequest value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.HsmResponse, $0.Empty>(
        'RespondHsmRequest',
        respondHsmRequest_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.HsmResponse.fromBuffer(value),
        ($0.Empty value) => value.writeToBuffer()));
  }

  $async.Future<$0.GetInfoResponse> getInfo_Pre(
      $grpc.ServiceCall call, $async.Future<$0.GetInfoRequest> request) async {
    return getInfo(call, await request);
  }

  $async.Future<$0.StopResponse> stop_Pre(
      $grpc.ServiceCall call, $async.Future<$0.StopRequest> request) async {
    return stop(call, await request);
  }

  $async.Future<$0.ConnectResponse> connectPeer_Pre(
      $grpc.ServiceCall call, $async.Future<$0.ConnectRequest> request) async {
    return connectPeer(call, await request);
  }

  $async.Future<$0.ListPeersResponse> listPeers_Pre($grpc.ServiceCall call,
      $async.Future<$0.ListPeersRequest> request) async {
    return listPeers(call, await request);
  }

  $async.Future<$0.DisconnectResponse> disconnect_Pre($grpc.ServiceCall call,
      $async.Future<$0.DisconnectRequest> request) async {
    return disconnect(call, await request);
  }

  $async.Future<$0.NewAddrResponse> newAddr_Pre(
      $grpc.ServiceCall call, $async.Future<$0.NewAddrRequest> request) async {
    return newAddr(call, await request);
  }

  $async.Future<$0.ListFundsResponse> listFunds_Pre($grpc.ServiceCall call,
      $async.Future<$0.ListFundsRequest> request) async {
    return listFunds(call, await request);
  }

  $async.Future<$0.WithdrawResponse> withdraw_Pre(
      $grpc.ServiceCall call, $async.Future<$0.WithdrawRequest> request) async {
    return withdraw(call, await request);
  }

  $async.Future<$0.FundChannelResponse> fundChannel_Pre($grpc.ServiceCall call,
      $async.Future<$0.FundChannelRequest> request) async {
    return fundChannel(call, await request);
  }

  $async.Future<$0.CloseChannelResponse> closeChannel_Pre(
      $grpc.ServiceCall call,
      $async.Future<$0.CloseChannelRequest> request) async {
    return closeChannel(call, await request);
  }

  $async.Future<$0.Invoice> createInvoice_Pre(
      $grpc.ServiceCall call, $async.Future<$0.InvoiceRequest> request) async {
    return createInvoice(call, await request);
  }

  $async.Future<$0.Payment> pay_Pre(
      $grpc.ServiceCall call, $async.Future<$0.PayRequest> request) async {
    return pay(call, await request);
  }

  $async.Future<$0.Payment> keysend_Pre(
      $grpc.ServiceCall call, $async.Future<$0.KeysendRequest> request) async {
    return keysend(call, await request);
  }

  $async.Future<$0.ListPaymentsResponse> listPayments_Pre(
      $grpc.ServiceCall call,
      $async.Future<$0.ListPaymentsRequest> request) async {
    return listPayments(call, await request);
  }

  $async.Future<$0.ListInvoicesResponse> listInvoices_Pre(
      $grpc.ServiceCall call,
      $async.Future<$0.ListInvoicesRequest> request) async {
    return listInvoices(call, await request);
  }

  $async.Stream<$0.IncomingPayment> streamIncoming_Pre($grpc.ServiceCall call,
      $async.Future<$0.StreamIncomingFilter> request) async* {
    yield* streamIncoming(call, await request);
  }

  $async.Stream<$0.LogEntry> streamLog_Pre($grpc.ServiceCall call,
      $async.Future<$0.StreamLogRequest> request) async* {
    yield* streamLog(call, await request);
  }

  $async.Stream<$0.HsmRequest> streamHsmRequests_Pre(
      $grpc.ServiceCall call, $async.Future<$0.Empty> request) async* {
    yield* streamHsmRequests(call, await request);
  }

  $async.Future<$0.Empty> respondHsmRequest_Pre(
      $grpc.ServiceCall call, $async.Future<$0.HsmResponse> request) async {
    return respondHsmRequest(call, await request);
  }

  $async.Future<$0.GetInfoResponse> getInfo(
      $grpc.ServiceCall call, $0.GetInfoRequest request);
  $async.Future<$0.StopResponse> stop(
      $grpc.ServiceCall call, $0.StopRequest request);
  $async.Future<$0.ConnectResponse> connectPeer(
      $grpc.ServiceCall call, $0.ConnectRequest request);
  $async.Future<$0.ListPeersResponse> listPeers(
      $grpc.ServiceCall call, $0.ListPeersRequest request);
  $async.Future<$0.DisconnectResponse> disconnect(
      $grpc.ServiceCall call, $0.DisconnectRequest request);
  $async.Future<$0.NewAddrResponse> newAddr(
      $grpc.ServiceCall call, $0.NewAddrRequest request);
  $async.Future<$0.ListFundsResponse> listFunds(
      $grpc.ServiceCall call, $0.ListFundsRequest request);
  $async.Future<$0.WithdrawResponse> withdraw(
      $grpc.ServiceCall call, $0.WithdrawRequest request);
  $async.Future<$0.FundChannelResponse> fundChannel(
      $grpc.ServiceCall call, $0.FundChannelRequest request);
  $async.Future<$0.CloseChannelResponse> closeChannel(
      $grpc.ServiceCall call, $0.CloseChannelRequest request);
  $async.Future<$0.Invoice> createInvoice(
      $grpc.ServiceCall call, $0.InvoiceRequest request);
  $async.Future<$0.Payment> pay($grpc.ServiceCall call, $0.PayRequest request);
  $async.Future<$0.Payment> keysend(
      $grpc.ServiceCall call, $0.KeysendRequest request);
  $async.Future<$0.ListPaymentsResponse> listPayments(
      $grpc.ServiceCall call, $0.ListPaymentsRequest request);
  $async.Future<$0.ListInvoicesResponse> listInvoices(
      $grpc.ServiceCall call, $0.ListInvoicesRequest request);
  $async.Stream<$0.IncomingPayment> streamIncoming(
      $grpc.ServiceCall call, $0.StreamIncomingFilter request);
  $async.Stream<$0.LogEntry> streamLog(
      $grpc.ServiceCall call, $0.StreamLogRequest request);
  $async.Stream<$0.HsmRequest> streamHsmRequests(
      $grpc.ServiceCall call, $0.Empty request);
  $async.Future<$0.Empty> respondHsmRequest(
      $grpc.ServiceCall call, $0.HsmResponse request);
}

class HsmClient extends $grpc.Client {
  static final _$request = $grpc.ClientMethod<$0.HsmRequest, $0.HsmResponse>(
      '/greenlight.Hsm/Request',
      ($0.HsmRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.HsmResponse.fromBuffer(value));
  static final _$ping = $grpc.ClientMethod<$0.Empty, $0.Empty>(
      '/greenlight.Hsm/Ping',
      ($0.Empty value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.Empty.fromBuffer(value));

  HsmClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options, interceptors: interceptors);

  $grpc.ResponseFuture<$0.HsmResponse> request($0.HsmRequest request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$request, request, options: options);
  }

  $grpc.ResponseFuture<$0.Empty> ping($0.Empty request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$ping, request, options: options);
  }
}

abstract class HsmServiceBase extends $grpc.Service {
  $core.String get $name => 'greenlight.Hsm';

  HsmServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.HsmRequest, $0.HsmResponse>(
        'Request',
        request_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.HsmRequest.fromBuffer(value),
        ($0.HsmResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Empty, $0.Empty>(
        'Ping',
        ping_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Empty.fromBuffer(value),
        ($0.Empty value) => value.writeToBuffer()));
  }

  $async.Future<$0.HsmResponse> request_Pre(
      $grpc.ServiceCall call, $async.Future<$0.HsmRequest> hRequest) async {
    return request(call, await hRequest);
  }

  $async.Future<$0.Empty> ping_Pre(
      $grpc.ServiceCall call, $async.Future<$0.Empty> request) async {
    return ping(call, await request);
  }

  $async.Future<$0.HsmResponse> request(
      $grpc.ServiceCall call, $0.HsmRequest request);
  $async.Future<$0.Empty> ping($grpc.ServiceCall call, $0.Empty request);
}
