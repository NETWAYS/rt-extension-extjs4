Plugin('RT::Extension::SearchResult');

Set($SearchResult_HighlightOnLastUpdatedByCondition, [{
  'conditions' => { 'groups' => [ 'NETWAYS' ] },
  'color'      => 'yellow-dark',
  'icon'       => 'fa-exclamation-circle'
}]);

Set($SearchResult_HighlightOnDueDate, [ {
  'conditions' => { 'due' => 0 },
  'color'      => 'red-dark',
  'icon'       => 'fa-question-circle'
}, {
  'conditions' => { 'due' => 3 },
  'color'      => 'red-light',
  'icon'       => 'fa-question-circle'
}]);
