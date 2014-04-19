#!perl

if (!require Test::Perl::Critic) {
    Test::More::plan(
        skip_all => "Test::Perl::Critic required for testing."
    );
}

Test::Perl::Critic::all_critic_ok();
