///
//  Generated code. Do not modify.
//  source: scheduler.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

import 'dart:async' as $async;

import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'scheduler.pb.dart' as $0;
export 'scheduler.pb.dart';

class SchedulerClient extends $grpc.Client {
  static final _$register =
      $grpc.ClientMethod<$0.RegistrationRequest, $0.RegistrationResponse>(
          '/scheduler.Scheduler/Register',
          ($0.RegistrationRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              $0.RegistrationResponse.fromBuffer(value));
  static final _$recover =
      $grpc.ClientMethod<$0.RecoveryRequest, $0.RecoveryResponse>(
          '/scheduler.Scheduler/Recover',
          ($0.RecoveryRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              $0.RecoveryResponse.fromBuffer(value));
  static final _$getChallenge =
      $grpc.ClientMethod<$0.ChallengeRequest, $0.ChallengeResponse>(
          '/scheduler.Scheduler/GetChallenge',
          ($0.ChallengeRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              $0.ChallengeResponse.fromBuffer(value));
  static final _$schedule =
      $grpc.ClientMethod<$0.ScheduleRequest, $0.NodeInfoResponse>(
          '/scheduler.Scheduler/Schedule',
          ($0.ScheduleRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              $0.NodeInfoResponse.fromBuffer(value));
  static final _$getNodeInfo =
      $grpc.ClientMethod<$0.NodeInfoRequest, $0.NodeInfoResponse>(
          '/scheduler.Scheduler/GetNodeInfo',
          ($0.NodeInfoRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              $0.NodeInfoResponse.fromBuffer(value));
  static final _$maybeUpgrade =
      $grpc.ClientMethod<$0.UpgradeRequest, $0.UpgradeResponse>(
          '/scheduler.Scheduler/MaybeUpgrade',
          ($0.UpgradeRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              $0.UpgradeResponse.fromBuffer(value));

  SchedulerClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options, interceptors: interceptors);

  $grpc.ResponseFuture<$0.RegistrationResponse> register(
      $0.RegistrationRequest request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$register, request, options: options);
  }

  $grpc.ResponseFuture<$0.RecoveryResponse> recover($0.RecoveryRequest request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$recover, request, options: options);
  }

  $grpc.ResponseFuture<$0.ChallengeResponse> getChallenge(
      $0.ChallengeRequest request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$getChallenge, request, options: options);
  }

  $grpc.ResponseFuture<$0.NodeInfoResponse> schedule($0.ScheduleRequest request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$schedule, request, options: options);
  }

  $grpc.ResponseFuture<$0.NodeInfoResponse> getNodeInfo(
      $0.NodeInfoRequest request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$getNodeInfo, request, options: options);
  }

  $grpc.ResponseFuture<$0.UpgradeResponse> maybeUpgrade(
      $0.UpgradeRequest request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$maybeUpgrade, request, options: options);
  }
}

abstract class SchedulerServiceBase extends $grpc.Service {
  $core.String get $name => 'scheduler.Scheduler';

  SchedulerServiceBase() {
    $addMethod(
        $grpc.ServiceMethod<$0.RegistrationRequest, $0.RegistrationResponse>(
            'Register',
            register_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.RegistrationRequest.fromBuffer(value),
            ($0.RegistrationResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.RecoveryRequest, $0.RecoveryResponse>(
        'Recover',
        recover_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.RecoveryRequest.fromBuffer(value),
        ($0.RecoveryResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ChallengeRequest, $0.ChallengeResponse>(
        'GetChallenge',
        getChallenge_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.ChallengeRequest.fromBuffer(value),
        ($0.ChallengeResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ScheduleRequest, $0.NodeInfoResponse>(
        'Schedule',
        schedule_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.ScheduleRequest.fromBuffer(value),
        ($0.NodeInfoResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.NodeInfoRequest, $0.NodeInfoResponse>(
        'GetNodeInfo',
        getNodeInfo_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.NodeInfoRequest.fromBuffer(value),
        ($0.NodeInfoResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.UpgradeRequest, $0.UpgradeResponse>(
        'MaybeUpgrade',
        maybeUpgrade_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.UpgradeRequest.fromBuffer(value),
        ($0.UpgradeResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.RegistrationResponse> register_Pre($grpc.ServiceCall call,
      $async.Future<$0.RegistrationRequest> request) async {
    return register(call, await request);
  }

  $async.Future<$0.RecoveryResponse> recover_Pre(
      $grpc.ServiceCall call, $async.Future<$0.RecoveryRequest> request) async {
    return recover(call, await request);
  }

  $async.Future<$0.ChallengeResponse> getChallenge_Pre($grpc.ServiceCall call,
      $async.Future<$0.ChallengeRequest> request) async {
    return getChallenge(call, await request);
  }

  $async.Future<$0.NodeInfoResponse> schedule_Pre(
      $grpc.ServiceCall call, $async.Future<$0.ScheduleRequest> request) async {
    return schedule(call, await request);
  }

  $async.Future<$0.NodeInfoResponse> getNodeInfo_Pre(
      $grpc.ServiceCall call, $async.Future<$0.NodeInfoRequest> request) async {
    return getNodeInfo(call, await request);
  }

  $async.Future<$0.UpgradeResponse> maybeUpgrade_Pre(
      $grpc.ServiceCall call, $async.Future<$0.UpgradeRequest> request) async {
    return maybeUpgrade(call, await request);
  }

  $async.Future<$0.RegistrationResponse> register(
      $grpc.ServiceCall call, $0.RegistrationRequest request);
  $async.Future<$0.RecoveryResponse> recover(
      $grpc.ServiceCall call, $0.RecoveryRequest request);
  $async.Future<$0.ChallengeResponse> getChallenge(
      $grpc.ServiceCall call, $0.ChallengeRequest request);
  $async.Future<$0.NodeInfoResponse> schedule(
      $grpc.ServiceCall call, $0.ScheduleRequest request);
  $async.Future<$0.NodeInfoResponse> getNodeInfo(
      $grpc.ServiceCall call, $0.NodeInfoRequest request);
  $async.Future<$0.UpgradeResponse> maybeUpgrade(
      $grpc.ServiceCall call, $0.UpgradeRequest request);
}
