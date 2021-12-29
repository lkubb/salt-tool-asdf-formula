{%- from 'tool-asdf/map.jinja' import asdf %}

{%- for user in asdf.users | selectattr('asdf.direnv') | selectattr('asdf.integrate-direnv') %}
asdf is integrated into direnv for '{{ user.name }}':
  file.append:
    - name: {{ user.xdg.config }}/direnv/direnvrc
    - text: source "$(asdf direnv hook asdf)"
    - user: {{ user.name }}
    - group: {{ user.group }}
    - mode: '0600'
    - makedirs: true
{%- endfor %}
