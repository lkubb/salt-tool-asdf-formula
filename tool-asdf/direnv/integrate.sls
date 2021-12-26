{%- for user in salt['pillar.get']('tool:asdf', []) | selectattr('direnv') %}
{%- from 'tool-asdf/map.jinja' import user, xdg with context %}
asdf is integrated into direnv for '{{ user.name }}':
  file.append:
    - name: {{ xdg.config }}/direnv/direnvrc
    - text: source "$(asdf direnv hook asdf)"
    - user: {{ user.name }}
    - group: {{ user.group }}
    - mode: '0600'
{%- endfor %}
