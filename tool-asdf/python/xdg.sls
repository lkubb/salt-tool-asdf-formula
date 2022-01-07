{%- from 'tool-asdf/golang/map.jinja' import users -%}

include:
  - .package

{%- for user in users | rejectattr('xdg', 'sameas', False) %}
asdf python plugin global configuration is migrated to XDG_CONFIG_HOME for user '{{ user.name }}':
  file.rename:
    - name: {{ user.xdg.config }}/asdf/default-python-packages
    - source: {{ user.home }}/.default-python-packages
    - makedirs: true
    - onlyif:
      - test -e {{ user.home }}/.default-python-packages
    - prereq_in:
  {%- for version in user.asdf.python %}
      - Python {{ version }} is installed for user '{{ user.name }}'
  {%- endfor %}

asdf python uses XDG dirs during this salt run:
  environ.setenv:
    - value:
        ASDF_PYTHON_DEFAULT_PACKAGES_FILE: "{{ user.xdg.config }}/asdf/default-python-packages"
    - prereq_in:
  {%- for version in user.asdf.python %}
      - Python {{ version }} is installed for user '{{ user.name }}'
  {%- endfor %}

  {%- if user.get('persistenv') %}
asdf python plugin knows about XDG location for user '{{ user.name }}':
  file.append:
    - name: {{ user.home }}/{{ user.persistenv }}
    - text: export ASDF_PYTHON_DEFAULT_PACKAGES_FILE="${XDG_CONFIG_HOME:-$HOME/.config}/asdf/default-python-packages"
    - user: {{ user.name }}
    - group: {{ user.group }}
    - mode: '0600'
    - prereq_in:
    {%- for version in user.asdf.python %}
      - Python {{ version }} is installed for user '{{ user.name }}'
    {%- endfor %}
  {%- endif %}
{%- endfor %}
