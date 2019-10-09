package MOME;

# Mrs. O'Leary's Music Education
# Code to manage Beth's business

use JSON::MaybeXS;
use Net::Google::DataAPI::Auth::OAuth2;
use Net::Google::Spreadsheets;
use Net::OAuth2::AccessToken;
use Perl6::Slurp;
use Storable qw/retrieve/;

use warnings;
use strict;

#Token file
my $TOKEN_FILE = "billing-client-token";

# Returns an authenticated agent for accesing Google Drive spreadsheets
sub google_sheets {
    my $token = retrieve($TOKEN_FILE);

    my $client_credentials = decode_json(slurp('billing-client-auth.json'));

    my $oauth2 = Net::Google::DataAPI::Auth::OAuth2->new(
        client_id => $client_credentials->{installed}{client_id},
        client_secret =>$client_credentials->{installed}{client_secret},
        scope => ['http://spreadsheets.google.com/feeds/'],
        redirect_uri => 'http://localhost/authorize/',
    );

    my $restored_token =
        Net::OAuth2::AccessToken->session_thaw(
            $token,
            auto_refresh => 1,
            profile => $oauth2->oauth2_webserver,
        );

    $oauth2->access_token($restored_token);

    return Net::Google::Spreadsheets->new(auth => $oauth2);
}
