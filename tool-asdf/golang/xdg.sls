{%- for user in salt['pillar.get']('tool:asdf', []) | rejectattr('xdg', 'sameas', False) %}
  {%- from 'tool-asdf/map.jinja' import user, xdg with context %}

asdf python plugin global configuration is migrated to XDG_CONFIG_HOME for user '{{ user.name }}':
  file.rename:
    - name: {{ xdg.config }}/asdf/default-golang-packages
    - source: {{ user.home }}/.default-golang-packages
    - makedirs: true

asdf golang uses XDG dirs during this salt run:
  environ.setenv:
    - value:
        ASDF_GOLANG_DEFAULT_PACKAGES_FILE: "{{ xdg.config }}/asdf/default-golang-packages"

  {%- if user.persistenv %}
asdf golang plugin knows about XDG location for user '{{ user.name }}':
  file.append:
    - name: {{ user.home }}/{{ user.persistenv }}
    - text: export ASDF_GOLANG_DEFAULT_PACKAGES_FILE="${XDG_CONFIG_HOME:-$HOME/.config}/asdf/default-golang-packages"
    - user: {{ user.name }}
    - group: {{ user.group }}
    - mode: '0600'
  {%- endif %}
{%- endfor %}