{%- from 'tool-asdf/golang/map.jinja' import dependencies, users -%}

{%- for user in users | rejectattr('xdg', 'sameas', False) %}
asdf python plugin global configuration is migrated to XDG_CONFIG_HOME for user '{{ user.name }}':
  file.rename:
    - name: {{ user.xdg.config }}/asdf/default-golang-packages
    - source: {{ user.home }}/.default-golang-packages
    - makedirs: true

asdf golang uses XDG dirs during this salt run:
  environ.setenv:
    - value:
        ASDF_GOLANG_DEFAULT_PACKAGES_FILE: "{{ user.xdg.config }}/asdf/default-golang-packages"

  {%- if user.get('persistenv') %}
asdf golang plugin knows about XDG location for user '{{ user.name }}':
  file.append:
    - name: {{ user.home }}/{{ user.persistenv }}
    - text: export ASDF_GOLANG_DEFAULT_PACKAGES_FILE="${XDG_CONFIG_HOME:-$HOME/.config}/asdf/default-golang-packages"
    - user: {{ user.name }}
    - group: {{ user.group }}
    - mode: '0600'
  {%- endif %}
{%- endfor %}
