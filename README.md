# Name

Unexpected - Exception class composed from traits

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

# Version

This documents version v0.13.$Rev: 0 $ of [Unexpected](https://metacpan.org/module/Unexpected)

# Description

An exception class that supports error messages with placeholders, a
[throw](https://metacpan.org/module/Unexpected::TraitFor::Throwing#throw) method with automatic
re-throw upon detection of self, conditional throw if an exception was
caught and a simplified stack trace in addition to the error message
with full stack trace

# Configuration and Environment

Applies exception roles to the exception base class [Unexpected](https://metacpan.org/module/Unexpected). See
["Dependencies"](#Dependencies) for the list of roles that are applied

Error objects are overloaded to stringify to the full error message
plus a leader if the optional `ErrorLeader` role has been applied

# Subroutines/Methods

## BUILDARGS

Customizes the constructor. Accepts either a coderef, an object ref,
a hashref, a scalar, or a list of key / value pairs

## BUILD

Does nothing placeholder that allows the applied roles to modify it

## is\_one\_of\_us

    $bool = $class->is_one_of_us( $string_or_exception_object_ref );

Class method which detects instances of this exception class

# Diagnostics

String overload is performed in this class as opposed to the stringify
error role since overloading is not supported in [Moo::Role](https://metacpan.org/module/Moo::Role)

# Dependencies

- [namespace::sweep](https://metacpan.org/module/namespace::sweep)
- [overload](https://metacpan.org/module/overload)
- [Moo](https://metacpan.org/module/Moo)
- [Unexpected::TraitFor::Exception::Classes](https://metacpan.org/module/Unexpected::TraitFor::Exception::Classes)
- [Unexpected::TraitFor::StringifyingError](https://metacpan.org/module/Unexpected::TraitFor::StringifyingError)
- [Unexpected::TraitFor::Throwing](https://metacpan.org/module/Unexpected::TraitFor::Throwing)
- [Unexpected::TraitFor::TracingStacks](https://metacpan.org/module/Unexpected::TraitFor::TracingStacks)

# Incompatibilities

There are no known incompatibilities in this module

# Bugs and Limitations

[Throwable](https://metacpan.org/module/Throwable) did not let me use the stack trace filter directly, it's wrapped
inside an attribute constructor. There was nothing else in [Throwable](https://metacpan.org/module/Throwable)
that would not have been overridden

There are no known bugs in this module.  Please report problems to
http://rt.cpan.org/NoAuth/Bugs.html?Dist=Unexpected. Patches
are welcome

# Acknowledgements

Larry Wall - For the Perl programming language

[Throwable::Error](https://metacpan.org/module/Throwable::Error) - Lifted the stack frame filter from here

John Sargent - Came up with the package name

# Author

Peter Flanigan, `<pjfl@cpan.org>`

# License and Copyright

Copyright (c) 2013 Peter Flanigan. All rights reserved

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself. See [perlartistic](https://metacpan.org/module/perlartistic)

This program is distributed in the hope that it will be useful,
but WITHOUT WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE
