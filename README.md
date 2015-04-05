<div>
    <a href="https://travis-ci.org/pjfl/p5-unexpected"><img src="https://travis-ci.org/pjfl/p5-unexpected.png" alt="Travis CI Badge"></a>
    <a href="https://coveralls.io/r/pjfl/p5-unexpected?branch=master"><img src="https://coveralls.io/repos/pjfl/p5-unexpected/badge.png" alt="Coveralls Badge"></a>
    <a href="http://badge.fury.io/pl/Unexpected"><img src="https://badge.fury.io/pl/Unexpected.svg" alt="CPAN Badge"></a>
    <a href="http://cpants.cpanauthors.org/dist/Unexpected"><img src="http://cpants.cpanauthors.org/dist/Unexpected.png" alt="Kwalitee Badge"></a>
</div>

# Name

Unexpected - Localised exception classes composed from roles

# Synopsis

    package YourApp::Exception;

    use Moo;

    extends 'Unexpected';
    with    'Unexpected::TraitFor::ErrorLeader';

    __PACKAGE__->ignore_class( 'YourApp::IgnoreMe' );

    has '+class' => default => __PACKAGE__;

    package YourApp;

    use YourApp::Exception;
    use Try::Tiny;

    sub some_method {
       my $self = shift;

       try   { this_will_fail }
       catch { YourApp::Exception->throw $_ };
    }

    # OR

    sub some_method {
       my $self = shift;

       eval { this_will_fail };
       YourApp::Exception->throw_on_error;
    }

    # THEN
    try   { $self->some_method() }
    catch { warn $_->message };

# Description

An exception class that supports error messages with placeholders, a
[throw](https://metacpan.org/pod/Unexpected::TraitFor::Throwing#throw) method with automatic
re-throw upon detection of self, conditional throw if an exception was
caught and a simplified stack trace in addition to the error message
with full stack trace

# Configuration and Environment

Applies exception roles to the exception base class [Unexpected](https://metacpan.org/pod/Unexpected). See
["Dependencies"](#dependencies) for the list of roles that are applied

The list of constructor methods signatures is described in
[build\_attr\_from](https://metacpan.org/pod/Unexpected::Functions#build_attr_from)

Error objects are overloaded to stringify to the full error message
plus a leader if the optional `ErrorLeader` role has been applied

# Subroutines/Methods

## BUILD

Dummy subroutine which is modified by the applied roles

## BUILDARGS

Differentiates different constructor method signatures

# Diagnostics

String overload is performed in this class as opposed to the stringify
error role since overloading is not supported in [Moo::Role](https://metacpan.org/pod/Moo::Role)

# Dependencies

- [namespace::autoclean](https://metacpan.org/pod/namespace::autoclean)
- [overload](https://metacpan.org/pod/overload)
- [Moo](https://metacpan.org/pod/Moo)
- [Unexpected::TraitFor::ExceptionClasses](https://metacpan.org/pod/Unexpected::TraitFor::ExceptionClasses)
- [Unexpected::TraitFor::StringifyingError](https://metacpan.org/pod/Unexpected::TraitFor::StringifyingError)
- [Unexpected::TraitFor::Throwing](https://metacpan.org/pod/Unexpected::TraitFor::Throwing)
- [Unexpected::TraitFor::TracingStacks](https://metacpan.org/pod/Unexpected::TraitFor::TracingStacks)

# Incompatibilities

There are no known incompatibilities in this module

# Bugs and Limitations

[Throwable](https://metacpan.org/pod/Throwable) did not let me use the stack trace filter directly, it's wrapped
inside an attribute constructor. There was nothing else in [Throwable](https://metacpan.org/pod/Throwable)
that would not have been overridden

There are no known bugs in this module.  Please report problems to
http://rt.cpan.org/NoAuth/Bugs.html?Dist=Unexpected. Patches
are welcome

# Acknowledgements

Larry Wall - For the Perl programming language

[Throwable::Error](https://metacpan.org/pod/Throwable::Error) - Lifted the stack frame filter from here

John Sargent - Came up with the package name

# Author

Peter Flanigan, `<pjfl@cpan.org>`

# License and Copyright

Copyright (c) 2014 Peter Flanigan. All rights reserved

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself. See [perlartistic](https://metacpan.org/pod/perlartistic)

This program is distributed in the hope that it will be useful,
but WITHOUT WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE
