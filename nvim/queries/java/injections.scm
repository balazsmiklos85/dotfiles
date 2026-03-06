; extends
(variable_declarator
  name: (identifier) @name (#match? @name "sql|query|SQL")
  value: (string_literal (string_content) @injection.content)
  (#set! injection.language "sql"))
