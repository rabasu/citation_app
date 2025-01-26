// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'folder_list_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$folderListHash() => r'c2b02acbd420766ae7f0af9c3947e4580065d92b';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$FolderList
    extends BuildlessAutoDisposeAsyncNotifier<List<Folder>> {
  late final int? folderId;

  FutureOr<List<Folder>> build([
    int? folderId,
  ]);
}

/// See also [FolderList].
@ProviderFor(FolderList)
const folderListProvider = FolderListFamily();

/// See also [FolderList].
class FolderListFamily extends Family<AsyncValue<List<Folder>>> {
  /// See also [FolderList].
  const FolderListFamily();

  /// See also [FolderList].
  FolderListProvider call([
    int? folderId,
  ]) {
    return FolderListProvider(
      folderId,
    );
  }

  @override
  FolderListProvider getProviderOverride(
    covariant FolderListProvider provider,
  ) {
    return call(
      provider.folderId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'folderListProvider';
}

/// See also [FolderList].
class FolderListProvider
    extends AutoDisposeAsyncNotifierProviderImpl<FolderList, List<Folder>> {
  /// See also [FolderList].
  FolderListProvider([
    int? folderId,
  ]) : this._internal(
          () => FolderList()..folderId = folderId,
          from: folderListProvider,
          name: r'folderListProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$folderListHash,
          dependencies: FolderListFamily._dependencies,
          allTransitiveDependencies:
              FolderListFamily._allTransitiveDependencies,
          folderId: folderId,
        );

  FolderListProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.folderId,
  }) : super.internal();

  final int? folderId;

  @override
  FutureOr<List<Folder>> runNotifierBuild(
    covariant FolderList notifier,
  ) {
    return notifier.build(
      folderId,
    );
  }

  @override
  Override overrideWith(FolderList Function() create) {
    return ProviderOverride(
      origin: this,
      override: FolderListProvider._internal(
        () => create()..folderId = folderId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        folderId: folderId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<FolderList, List<Folder>>
      createElement() {
    return _FolderListProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FolderListProvider && other.folderId == folderId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, folderId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin FolderListRef on AutoDisposeAsyncNotifierProviderRef<List<Folder>> {
  /// The parameter `folderId` of this provider.
  int? get folderId;
}

class _FolderListProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<FolderList, List<Folder>>
    with FolderListRef {
  _FolderListProviderElement(super.provider);

  @override
  int? get folderId => (origin as FolderListProvider).folderId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
