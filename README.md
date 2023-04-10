# Resolvable

A library for working with resolvables. Resolvables are similar to promises or futures.
This library can save add-on developers some work.

## Things included

* **Resolvable.Resolvable**: a class for a resolvable.
  * **Resolvable.Resolvable**:new: a constructor for creating a resolvable.
  * **Resolvable.Resolvable:afterResolve** / **Resolvable.Resolvable**.after: a method for registering a callback which is called after the resolvable is resolved.
  * **await** / **Resolvable.await**: a function for awaiting on a promise. Can only be used in a coroutine.
  * **Resolvable.all**: a function for creating a new resolvable which resolves when all resolvables, that have been passed, have been resolved.

"**Resolvable.Resolvable:new**" returns a second return value, which is a table with internal methods which can be used
by the creator of the resolvable. Those include:

* **resolve**: a method to resolve the resolvable.
