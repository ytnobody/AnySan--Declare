use strict;
use warnings;
use FindBin;
use lib ("$FindBin::Bin/../lib");
use AnySan::Declare;

set_provider
    IRC => 'chat.freenode.net',
    nickname => 'nikolashka',
    channels => {
        '#ytnobody' => {},
    }
;

rule qr/^hoge (.+?)$/ => sub {
    my $r = shift;
    $r->send_replay( join( ' ', $r->from_nickname, 'hello!' ) );
    $r->send_replay( 'you said "'. $_[0] .'"' ) if $_[0];
};

start;
