Set($LDAPHost,'icinga-ldap2.icinga.netways.de');
Set($LDAPUser, 'cn=rt,ou=tools,dc=icinga,dc=com');
Set($LDAPPassword, '45JRpo6bri');
Set($LDAPBase, 'ou=user,dc=icinga,dc=com');
Set($LDAPFilter, '(|(memberof=cn=rt,ou=groups,dc=icinga,dc=com)(memberof=cn=all-access,ou=groups,dc=icinga,dc=com))');
Set($LDAPUpdateUsers, 1);
Set($LDAPMapping, {
    Name               => 'uid',
    EmailAddress       => 'mail',
    'RealName'         => ['givenName', 'sn'],
    'UserCF.Job Title' => 'title'
});
