# Name

Unexpected - Moose exception class composed from traits

# Synopsis

    use File::DataClass::Functions qw(throw);
    use Try::Tiny;

    sub some_method {
       my $self = shift;

       try   { this_will_fail }
       catch { throw $_ };
    }

    # OR
    use Unexpected;

    sub some_method {
       my $self = shift;

       eval { this_will_fail };
       Unexpected->throw_on_error;
    }

    # THEN
    try   { $self->some_method() }
    catch { warn $_."\n\n".$_->stacktrace."\n" };

# Version

This documents version v0.1.$Rev: 9 $ of [Unexpected](https://metacpan.org/module/Unexpected)

# Description

An exception class that supports error messages with placeholders, a
["throw" in Unexpected::TraitFor::Throwing](https://metacpan.org/module/Unexpected::TraitFor::Throwing#throw) method with
automatic re-throw upon detection of self, conditional throw if an
exception was caught and a simplified stacktrace

# Configuration and Environment

Applies exception roles to the exception base class
[Unexpected::Base](https://metacpan.org/module/Unexpected::Base). See ["Dependencies"](#Dependencies) for the list of
roles that are applied

Error objects are overloaded to stringify to the full error message
plus a leader if the optional `ErrorLeader` role has been applied

Defines these attributes;

- `class`

    Defaults to `__PACKAGE__`. Can be used to differentiate different
    classes of error

# Subroutines/Methods

## BUILD

Does nothing placeholder that allows the applied roles to modify it

## is\_one\_of\_us

    $bool = $class->is_one_of_us( $string_or_exception_object_ref );

Class method which detects instances of this exception class

# Diagnostics

None

# Dependencies

- [namespace::autoclean](https://metacpan.org/module/namespace::autoclean)
- [Moose](https://metacpan.org/module/Moose)
- [MooseX::Types::Common](https://metacpan.org/module/MooseX::Types::Common)
- [Unexpected::TraitFor::ErrorLeader](https://metacpan.org/module/Unexpected::TraitFor::ErrorLeader)
- [Unexpected::TraitFor::StringifyingError](https://metacpan.org/module/Unexpected::TraitFor::StringifyingError)
- [Unexpected::TraitFor::Throwing](https://metacpan.org/module/Unexpected::TraitFor::Throwing)
- [Unexpected::TraitFor::TracingStacks](https://metacpan.org/module/Unexpected::TraitFor::TracingStacks)

# Incompatibilities

There are no known incompatibilities in this module

# Bugs and Limitations

There are no known bugs in this module.
Please report problems to the address below.
Patches are welcome

# Acknowledgements

Larry Wall - For the Perl programming language

[Throwable::Error](https://metacpan.org/module/Throwable::Error) - Lifted the stack frame filter from here

# Author

Peter Flanigan, `<pjfl@cpan.org>`

# License and Copyright

Copyright (c) 2013 Peter Flanigan. All rights reserved

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself. See [perlartistic](https://metacpan.org/module/perlartistic)

This program is distributed in the hope that it will be useful,
but WITHOUT WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE
