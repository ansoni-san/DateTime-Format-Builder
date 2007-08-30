use strict;
use warnings;

use lib 't/lib';

use DateTime::Format::Builder;
use Test::More;

unless ( eval "use Test::Memory::Cycle; 1;" )
{
    plan skip_all => 'These tests require Test::Memory::Cycle.';
    exit;
}

plan tests => 4;

{
    my $builder = DateTime::Format::Builder->new();
    my $parser = $builder->parser( { strptime => '%Y-%m-%d' } );

    memory_cycle_ok( $parser,
                     'Make sure parser object does not have circular refs' );

    memory_cycle_ok( $builder,
                     'Make sure builder object does not have circular refs after making a single parser' );
}

{
    my $builder = DateTime::Format::Builder->new();
    my $parser = $builder->parser( { strptime => '%Y-%m-%d',
                                     strptime => '%d-%m-%Y',
                                   } );

    memory_cycle_ok( $parser,
                     'Make sure parser object does not have circular refs' );

    memory_cycle_ok( $builder,
                     'Make sure builder object does not have circular refs after making a multi parser' );
}

