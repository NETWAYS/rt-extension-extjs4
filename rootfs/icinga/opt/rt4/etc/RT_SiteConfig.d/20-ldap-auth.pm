Set($WebRemoteUserAuth, 1);
Set($WebFallbackToRTLogin, 1);
Set($AutoCreateNonExternalUsers, 1);
Set($ExternalAuthPriority, ['icinga-ldap']);
Set($ExternalInfoPriority, ['icinga-ldap']);
Set($UserAutocreateDefaultsOnLogin, {
  Privileged => 1
});
Set($ExternalSettings, {
  'icinga-ldap' => {
    'type' => 'ldap',
    'server' => 'icinga-ldap2.icinga.netways.de',
    'user' => 'cn=rt,ou=tools,dc=icinga,dc=com',
    'pass' => '45JRpo6bri',
    'base' => 'ou=user,dc=icinga,dc=com',
    'filter' => '(|(memberof=cn=rt,ou=groups,dc=icinga,dc=com)(memberof=cn=all-access,ou=groups,dc=icinga,dc=com))',
    'attr_match_list' => [
      'Name',
      'EmailAddress',
    ],
    'attr_map' => {
      'Name'         => 'uid',
      'EmailAddress' => 'mail',
    }
  }
});
