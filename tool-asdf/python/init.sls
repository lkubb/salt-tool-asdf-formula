include:
{%- if salt['pillar.get']('tool:asdf', []) | rejectattr('xdg', 'sameas', False) %}
  - .xdg
{%- endif %}
  - .package
