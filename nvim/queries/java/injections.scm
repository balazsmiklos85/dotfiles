; extends

((variable_declarator
  name: (identifier) @name (#match? @name "sql|query|SQL|QUERY")
  value: (string_literal
    (_) @injection.content))
  (#set! injection.language "sql")
  (#set! injection.combined))
