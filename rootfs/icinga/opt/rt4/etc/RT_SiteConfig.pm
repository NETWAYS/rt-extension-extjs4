Set($rtname, 'icinga');
Set($Organization, "icinga.org");

Set($WebDomain, 'rt.icinga.org');
Set($WebPath, "");
Set($WebPort, 443);
Set($WebRemoteUserAuth, 1);
Set($WebFallbackToRTLogin, 0);
Set($Timezone, "Europe/Berlin");

Set($DatabaseType, "mysql");
Set($DatabaseHost,   "mysql1.adm.netways.de");
Set($DatabaseUser, "rt4_user");
Set($DatabasePassword, q{R75qk8Pd6PNzgJX});
Set($DatabaseName, "rt4_icinga_support");

Set($LogToSyslog, "error");
Set($LogToSTDERR, undef);
Set($LogToFile, undef);
Set($LogStackTraces, undef);

# XSS referrer check
Set($RestrictReferrer, undef);

Set($MessageBoxIncludeSignature, undef);
Set($MessageBoxIncludeSignatureOnComment, undef);
Set($MessageBoxRichText, undef);
Set($TrustHTMLAttachments, 1);
Set($OldestTransactionsFirst, 0);

Set($MaxAttachmentSize, 25_000_000);
Set($ParseNewMessageForTicketCcs, 1);

# Set($RTAddressRegexp, '^.+\@rt.netways.de$');
Set($RTAddressRegexp, '^(nobody\@web\.|.+\@rt\.|(service|info|office|abuse|billing|changes|einkauf|events|fax|hardware|hostmaster|reports|.*support|sales|shop|sun|tradoria|tickets?|grafik|telekom|hq|jobs?)\@)icinga\.org$');
Set($CorrespondAddress , 'rt@rt.icinga.org');
Set($CommentAddress , 'xrt@rt.icinga.org');
Set($SetOutgoingMailFrom, 1);

# Default setting
Set($RedistributeAutoGeneratedMessages, "privileged");

Set($UsernameFormat, "verbose");
