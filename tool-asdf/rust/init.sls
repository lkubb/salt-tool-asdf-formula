{%- from 'tool-asdf/map.jinja' import asdf %}
{%- set users = asdf.users | selectattr('asdf.rust', 'defined') | list -%} {# casting to list ensures it can be imported #}

include:
{%- if users | rejectattr('xdg', 'sameas', False) | list %}
  - .xdg
{%- endif %}
  - .package
