# Name

Unexpected - Exception class composed from traits

# Synopsis

    package YourApp::Exception;

    use Moo;

    extends 'Unexpected';
    with    'Unexpected::TraitFor::ErrorLeader';

    __PACKAGE__->ignore_class( 'YourApp::IgnoreMe' );

    has '+class' => default => __PACKAGE__;

    sub message {
       my $self = shift; return $self."\n\n".$self->trace->as_string."\n";
    }

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

This documents version v0.2.$Rev: 1 $ of [Unexpected](https://metacpan.org/module/Unexpected)

# Description

An exception class that supports error messages with placeholders, a
["throw" in Unexpected::TraitFor::Throwing](https://metacpan.org/module/Unexpected::TraitFor::Throwing#throw) method with
automatic re-throw upon detection of self, conditional throw if an
exception was caught and a simplified stacktrace

# Configuration and Environment

Applies exception roles to the exception base class [Unexpected](https://metacpan.org/module/Unexpected). See
["Dependencies"](#Dependencies) for the list of roles that are applied

Error objects are overloaded to stringify to the full error message
plus a leader if the optional `ErrorLeader` role has been applied

Defines these attributes;

- `class`

    Defaults to `__PACKAGE__`. Can be used to differentiate different
    classes of error

# Subroutines/Methods

## BUILDARGS

Placeholder to shut [Pod::Coverage](https://metacpan.org/module/Pod::Coverage) up

## BUILD

Does nothing placeholder that allows the applied roles to modify it

## is\_one\_of\_us

    $bool = $class->is_one_of_us( $string_or_exception_object_ref );

Class method which detects instances of this exception class

# Diagnostics

None

# Dependencies

- [namespace::sweep](https://metacpan.org/module/namespace::sweep)
- [overload](https://metacpan.org/module/overload)
- [Moo](https://metacpan.org/module/Moo)
- [Unexpected::TraitFor::StringifyingError](https://metacpan.org/module/Unexpected::TraitFor::StringifyingError)
- [Unexpected::TraitFor::Throwing](https://metacpan.org/module/Unexpected::TraitFor::Throwing)
- [Unexpected::TraitFor::TracingStacks](https://metacpan.org/module/Unexpected::TraitFor::TracingStacks)
- [Unexpected::Types](https://metacpan.org/module/Unexpected::Types)

# Incompatibilities

There are no known incompatibilities in this module

# Bugs and Limitations

There are no known bugs in this module.
Please report problems to the address below.
Patches are welcome

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
