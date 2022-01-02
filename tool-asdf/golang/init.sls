{%- from 'tool-asdf/golang/map.jinja' import users -%}

include:
{%- if users | rejectattr('xdg', 'sameas', False) %}
  - .xdg
{%- endif %}
  - .package
