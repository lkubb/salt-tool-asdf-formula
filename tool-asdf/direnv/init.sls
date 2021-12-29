{%- from 'tool-asdf/map.jinja' import asdf %}

{%- set users = asdf.users | selectattr('asdf.direnv') -%}

include:
  - .package
{%- if users | selectattr('rchook') %}
  - .hook
{%- endif %}
{%- if users | selectattr('asdf.integrate-direnv') %}
  - .integrate
{%- endif %}
