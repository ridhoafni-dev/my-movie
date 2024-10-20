// Mocks generated by Mockito 5.4.4 from annotations
// in my_movie/test/presentation/pages/tv/now_playing_tv_series_page_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i7;
import 'dart:ui' as _i8;

import 'package:mockito/mockito.dart' as _i1;
import 'package:mockito/src/dummies.dart' as _i6;
import 'package:my_movie/common/state_enum.dart' as _i4;
import 'package:my_movie/domain/entity/tv/tv.dart' as _i5;
import 'package:my_movie/domain/usecases/tv/get_now_playing_tv_series.dart'
    as _i2;
import 'package:my_movie/presentation/providers/tv/now_playing_tv_series_notifier.dart'
    as _i3;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeGetNowPlayingTvSeries_0 extends _i1.SmartFake
    implements _i2.GetNowPlayingTvSeries {
  _FakeGetNowPlayingTvSeries_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [NowPlayingTvSeriesNotifier].
///
/// See the documentation for Mockito's code generation for more information.
class MockNowPlayingTvSeriesNotifier extends _i1.Mock
    implements _i3.NowPlayingTvSeriesNotifier {
  MockNowPlayingTvSeriesNotifier() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.GetNowPlayingTvSeries get useCaseGetNowPlayingTvSeries =>
      (super.noSuchMethod(
        Invocation.getter(#useCaseGetNowPlayingTvSeries),
        returnValue: _FakeGetNowPlayingTvSeries_0(
          this,
          Invocation.getter(#useCaseGetNowPlayingTvSeries),
        ),
      ) as _i2.GetNowPlayingTvSeries);

  @override
  set useCaseGetNowPlayingTvSeries(
          _i2.GetNowPlayingTvSeries? _useCaseGetNowPlayingTvSeries) =>
      super.noSuchMethod(
        Invocation.setter(
          #useCaseGetNowPlayingTvSeries,
          _useCaseGetNowPlayingTvSeries,
        ),
        returnValueForMissingStub: null,
      );

  @override
  _i4.RequestState get state => (super.noSuchMethod(
        Invocation.getter(#state),
        returnValue: _i4.RequestState.Empty,
      ) as _i4.RequestState);

  @override
  List<_i5.Tv> get nowPlayingTvSeries => (super.noSuchMethod(
        Invocation.getter(#nowPlayingTvSeries),
        returnValue: <_i5.Tv>[],
      ) as List<_i5.Tv>);

  @override
  String get message => (super.noSuchMethod(
        Invocation.getter(#message),
        returnValue: _i6.dummyValue<String>(
          this,
          Invocation.getter(#message),
        ),
      ) as String);

  @override
  bool get hasListeners => (super.noSuchMethod(
        Invocation.getter(#hasListeners),
        returnValue: false,
      ) as bool);

  @override
  _i7.Future<void> fetchNowPlayingTvSeries() => (super.noSuchMethod(
        Invocation.method(
          #fetchNowPlayingTvSeries,
          [],
        ),
        returnValue: _i7.Future<void>.value(),
        returnValueForMissingStub: _i7.Future<void>.value(),
      ) as _i7.Future<void>);

  @override
  void addListener(_i8.VoidCallback? listener) => super.noSuchMethod(
        Invocation.method(
          #addListener,
          [listener],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void removeListener(_i8.VoidCallback? listener) => super.noSuchMethod(
        Invocation.method(
          #removeListener,
          [listener],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void dispose() => super.noSuchMethod(
        Invocation.method(
          #dispose,
          [],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void notifyListeners() => super.noSuchMethod(
        Invocation.method(
          #notifyListeners,
          [],
        ),
        returnValueForMissingStub: null,
      );
}
