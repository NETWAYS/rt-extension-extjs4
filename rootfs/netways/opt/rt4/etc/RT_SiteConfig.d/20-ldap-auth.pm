# Authentication
Set($WebRemoteUserAuth, 1);
Set($WebFallbackToRTLogin, 1);
Set($AutoCreateNonExternalUsers, 1);
Set($ExternalAuthPriority, ['netways-ldap']);
Set($ExternalInfoPriority, ['netways-ldap']);
Set($UserAutocreateDefaultsOnLogin, {
  Privileged => 1
});
Set($ExternalSettings, {
  'netways-ldap' => {
    'type' => 'ldap',
    'server' => 'int.netways.de',
    'user' => 'netways-http@INT.NETWAYS.DE',
    'pass' => 'Zuriep2w',
    'base' => 'DC=int,DC=netways,DC=de',
    'filter' => '(&(objectClass=organizationalPerson)(userAccountControl:1.2.840.113556.1.4.803:=0)(memberOf=CN=net-rt-auth-HTTP,OU=AuthGroups,OU=NETWAYS,OU=NETRZ,OU=NETWAYS,DC=int,DC=netways,DC=de))',
    'd_filter' => '(&(userAccountControl:1.2.840.113556.1.4.803:=2))',
    'group' => 'CN=net-rt-auth-HTTP,OU=AuthGroups,OU=NETWAYS,OU=NETRZ,OU=NETWAYS,DC=int,DC=netways,DC=de',
    'group_attr' => 'member',
    'group_scope' => 'sub',
    'attr_match_list' => [
      'Name',
      'EmailAddress',
    ],
    'attr_map' => {
      'Name'         => 'sAMAccountName',
      'EmailAddress' => 'mail',
      'RealName'     => 'cn',
      'WorkPhone'    => 'telephoneNumber',
      'MobilePhone'  => 'mobile',
      'Address1'     => 'streetAddress',
      'City'         => 'l',
      'State'        => 'st',
      'Zip'          => 'postalCode',
      'Country'      => 'co',
      'NickName'     => 'initials',
      'Organization' => 'department'
    }
  }
});
