{%- from 'tool-asdf/golang/map.jinja' import dependencies, users -%}

include:
  - .package

{%- for user in users | rejectattr('xdg', 'sameas', False) %}
asdf python plugin global configuration is migrated to XDG_CONFIG_HOME for user '{{ user.name }}':
  file.rename:
    - name: {{ user.xdg.config }}/asdf/default-golang-packages
    - source: {{ user.home }}/.default-golang-packages
    - makedirs: true
    - onlyif:
      - test -e {{ user.home }}/.default-golang-packages
    - prereq_in:
  {%- for version in user.asdf.golang %}
      - Go {{ version }} is installed for user '{{ user.name }}'
  {%- endfor %}

asdf golang uses XDG dirs during this salt run:
  environ.setenv:
    - value:
        ASDF_GOLANG_DEFAULT_PACKAGES_FILE: "{{ user.xdg.config }}/asdf/default-golang-packages"
    - prereq_in:
  {%- for version in user.asdf.golang %}
      - Go {{ version }} is installed for user '{{ user.name }}'
  {%- endfor %}

  {%- if user.get('persistenv') %}

persistenv file for asdf golang for user '{{ user.name }}' exists:
  file.managed:
    - name: {{ user.home }}/{{ user.persistenv }}
    - user: {{ user.name }}
    - group: {{ user.group }}
    - mode: '0600'
    - dir_mode: '0700'
    - makedirs: true

asdf golang plugin knows about XDG location for user '{{ user.name }}':
  file.append:
    - name: {{ user.home }}/{{ user.persistenv }}
    - text: export ASDF_GOLANG_DEFAULT_PACKAGES_FILE="${XDG_CONFIG_HOME:-$HOME/.config}/asdf/default-golang-packages"
    - require:
      - persistenv file for asdf golang for user '{{ user.name }}' exists
    - prereq_in:
    {%- for version in user.asdf.golang %}
      - Go {{ version }} is installed for user '{{ user.name }}'
    {%- endfor %}
  {%- endif %}
{%- endfor %}
