Set(%GnuPG,
    Enable                 => 1,
    GnuPG                  => 'gpg',
    Passphrase             => undef,
    OutgoingMessagesFormat => "RFC", # Inline
);
Set(%SMIME,
    Enable => 1,
    OpenSSL => 'openssl',
    Keyring => q{var/data/smime},
    CAPath => undef,
    AcceptUntrustedCAs => undef,
    Passphrase => undef,
);
