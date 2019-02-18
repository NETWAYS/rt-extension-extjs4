Set($WebDomain, 'rt.netways.de');
Set($WebPath, "");
Set($WebPort, 443);
Set($RestrictReferrer, undef);
Set(@MasonParameters, (
       static_source => 1,
       buffer_preallocate_size => 16777216, # 16MB
       data_cache_defaults => {
           cache_class => "MemoryCache",
           cache_depth => 8
       },
       # preloads => ['/Elements/*']
));

Set($WebSecureCookies, 1);

Set($WebSessionClass, "Apache::Session::Redis");

Set(%WebSessionProperties,
    server => '127.0.0.1:6379',
    name   => 'rt4netways'
);
