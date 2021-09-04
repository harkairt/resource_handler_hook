import 'package:flutter/foundation.dart';
import 'package:dartz/dartz.dart';
import 'package:resource_handler/resource_handler.dart';
import 'package:resource_handler_hook/notifier_state.dart';

class _ResourceHandler with ResourceHandler {}

class ValueResourceHandlerHook<T, E> {
  ValueResourceHandlerHook(this._resourceNotifier);

  final ValueNotifier<ValueResource<T, E>> _resourceNotifier;
  final ResourceHandler _resourceHandler = _ResourceHandler();

  ValueResource<T, E> get resource => _resourceNotifier.value;
  ResourceState<T, E> get state => resource.state;

  void setState(ResourceState<T, E> state) {
    _notify(resource.copyWith(state));
  }

  Future<Either<E?, T>> fetch() => _resourceHandler.fetch(resource, emit: _notify);
  Future<Either<E?, T>> update(T payload) => _resourceHandler.update(
        resource,
        emit: _notify,
        payload: payload,
      );

  void _notify(Resource<T, E> resource) => _resourceNotifier.value;
}

ValueResourceHandlerHook<T, E> useValueResource<T, E>(ValueResource<T, E> resource) {
  final _resourceNotifier = useNotifierState(
    ValueNotifier<ValueResource<T, E>>(resource),
  );

  return ValueResourceHandlerHook<T, E>(_resourceNotifier);
}

class ListResourceHandlerHook<T extends Identifiable, E, PageType> {
  ListResourceHandlerHook(this._resourceNotifier);

  final ValueNotifier<ListResource<T, E, PageType>> _resourceNotifier;
  final ResourceHandler _resourceHandler = _ResourceHandler();

  ListResource<T, E, PageType> get resource => _resourceNotifier.value;
  ResourceState<List<T>, E> get state => resource.state;

  void setState(ResourceState<List<T>, E> state) {
    _notify(resource.copyWith(state));
  }

  Future<Either<E?, List<T>>> fetchPage() => _resourceHandler.fetchPage(resource, emit: _notify);
  Future<Either<E?, T?>> updateItem(T payload) => _resourceHandler.updateItem(
        resource,
        emit: _notify,
        payload: payload,
      );

  void _notify(Resource<List<T>, E> resource) {
    _resourceNotifier.value = resource as ListResource<T, E, PageType>;
  }
}

ListResourceHandlerHook<T, E, PageType> useListResource<T extends Identifiable, E, PageType>(
  ListResource<T, E, PageType> resource,
) {
  final _resourceNotifier = useNotifierState(ValueNotifier<ListResource<T, E, PageType>>(resource));
  return ListResourceHandlerHook<T, E, PageType>(_resourceNotifier);
}
