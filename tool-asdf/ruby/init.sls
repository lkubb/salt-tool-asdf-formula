{%- from 'tool-asdf/ruby/map.jinja' import users %}

include:
{%- if users | rejectattr('xdg', 'sameas', False) %}
  - .xdg
{%- endif %}
  - .package
