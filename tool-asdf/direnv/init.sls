{%- set users = salt['pillar.get']('tool:asdf', []) | selectattr('direnv') -%}
include:
  - .package
{%- if users | selectattr('hook') %}
  - .hook
{%- endif %}
{%- if users | selectattr('integrate') %}
  - .integrate
{%- endif %}
