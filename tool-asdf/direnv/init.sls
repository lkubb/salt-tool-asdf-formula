{%- from 'tool-asdf/map.jinja' import asdf %}

{%- set users = asdf.users | selectattr('asdf.direnv', 'defined') | list -%} {# casting to list ensures it can be imported #}

include:
  - .package
{%- if users | selectattr('rchook', 'defined') %}
  - .hook
{%- endif %}
{%- if users | selectattr('asdf.integrate-direnv', 'defined') | selectattr('asdf.integrate-direnv') %}
  - .integrate
{%- endif %}
