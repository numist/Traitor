Traits for Objective-C
======================

Traitor is a runtime-only implementation of traits for Objective-C, implemented in the spirit of [Traits: Composable Units of Behaviour](http://scg.unibe.ch/archive/papers/Scha03aTraits.pdf).

You should probably not rely on this for anything.

Limitations
-----------

Due to the lack of compiler support in this repository, the following limitations exist:

* The compiler will emit a warning when a trait does not implement the required methods of its ancestor traits.
* The compiler will emit a warning when a required method from one trait is implemented by another.
* Method collision detection is performed at runtime, not at compile-time.

Usage
-----

Coming soon, once some sufficiently complicated examples are finished.

To wit, a trait is two things:

* A protocol is declared with a set of required methods (that a final class must implement) and a set of optional methods (which the trait will provide implementations for, but may be overridden by the final class if desired). The protocol may conform to other trait protocols from which it inherits functionality (such as a mutable trait inheriting behaviour from its immutable counterpart).
* A class definition that shares the same name as the protocol and inherits from TRTrait. That class must implement all of the optional methods in the protocol, and it may (to shut up the compiler) implement the required methods with stubs that call `doesNotRecognizeSelector:` to reduce the incidence of compiler warnings.

To use traits, a class must:

* (For now) have TRTraitObject as an ancestor.
* Declare conformance to one or more trait protocols in a class or category declaration.
* Implement the required methods of those protocols.
