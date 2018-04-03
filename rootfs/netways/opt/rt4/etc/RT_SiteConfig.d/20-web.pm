Set($WebDomain, 'rt.netways.de');
Set($WebPath, "");
Set($WebPort, 443);

Set($RestrictReferrer, undef);

# Mason performance
Set(@MasonParameters, (
       static_source => 1,
       buffer_preallocate_size => 16777216, # 16MB
       data_cache_defaults => {
           cache_class => "MemoryCache",
           cache_depth => 8
       },
       # preloads => ['/Elements/*']
));

Set($WebSessionClass, "Apache::Session::File");
