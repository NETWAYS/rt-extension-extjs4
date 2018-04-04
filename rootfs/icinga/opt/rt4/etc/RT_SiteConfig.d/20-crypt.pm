Set(%GnuPG,
    Enable                 => 0,
    GnuPG                  => 'gpg',
    Passphrase             => undef,
    OutgoingMessagesFormat => "RFC", # Inline
);
Set(%SMIME,
    Enable => 0,
    OpenSSL => 'openssl',
    Keyring => q{var/data/smime},
    CAPath => undef,
    AcceptUntrustedCAs => undef,
    Passphrase => undef,
);
