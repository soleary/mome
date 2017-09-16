package My::Google::Sheets;

use Modern::Perl '2017';
use autodie;

use Cwd;

use parent 'Net::Google::Spreadsheets';

sub new {
    my %credentials = get_credentials();

    return Net::Google::Spreadsheets->new(%credentials);
}

sub get_credentials {

    my $file =

    my %credentials = ();

    open my $credfile, '<', cwd() . '/.google-drive-login';
    foreach my $key ( 'username', 'password' ) {
        my $line = <$credfile>;
        chomp $line;
        $credentials{$key} = $line;
    }

    use Data::Dumper;
    print Dumper \%credentials;

    return %credentials;
}

1;
