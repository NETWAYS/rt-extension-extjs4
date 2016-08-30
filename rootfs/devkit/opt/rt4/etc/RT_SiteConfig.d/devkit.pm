# rt4devkit configuration

Set($rtname, "rt4netways-dev");
Set($Organization, "netways.de");

Set($WebPort, 8080);

Set($Timezone, "Europe/Berlin");

Set($DatabaseType, "SQLite");

Set($LogToSyslog, undef);
Set($LogToSTDERR, "debug");
Set($LogToFile, "debug");
Set($LogDir, q{/opt/rt4/var});
Set($LogToFileNamed, "rt.log");
Set($LogStackTraces, undef);

Set($MailCommand, "mbox");
Set($RTAddressRegexp, '^.+\@localhost$');

Set($OldestTransactionsFirst, 0);
Set($TrustHTMLAttachments, undef);
Set($SuppressInlineTextFiles, undef);
Set($RestrictReferrer, 0);
Set($WebSessionClass, "Apache::Session::File");

Set($DevelMode, 1);
Set($StatementLog, 1);
Set($RecordBaseClass, "DBIx::SearchBuilder::Record::Cachable");
Set(@MasonParameters, (
       static_source => 1,
       buffer_preallocate_size => 16777216, # 16MB
       data_cache_defaults => {
           cache_class => "MemoryCache",
           cache_depth => 8
       },
       # preloads => ['/Elements/*']
));
# Set(@MasonParameters, (preamble => 'my $p = MasonX::Profiler->new($m, $r);'));

# Plugin();

1;
