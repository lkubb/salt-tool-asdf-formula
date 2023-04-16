# vim: ft=sls

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/direnv/init.sls" import users %}

include:
  - .package


{%- for user in users | selectattr("asdf.integrate_direnv", "defined") | selectattr("asdf.integrate_direnv") %}

# file.append does not accept owner/permission settings
asdf direnvrc exists for user '{{ user.name }}':
  file.managed:
    - name: {{ user.xdg.config | path_join(asdf.lookup.direnv_paths.xdg_dirname, asdf.lookup.direnv_paths.xdg_conffile) }}
    - user: {{ user.name }}
    - group: {{ user.group }}
    - mode: '0600'
    - dir_mode: '0700'
    - makedirs: true

asdf is integrated into direnv for '{{ user.name }}':
  file.append:
    - name: {{ user.xdg.config | path_join(asdf.lookup.direnv_paths.xdg_dirname, asdf.lookup.direnv_paths.xdg_conffile) }}
    - text: source "$(asdf direnv hook asdf)"
    - require:
      - asdf direnvrc exists for user '{{ user.name }}'
{%-   for version in user.asdf.direnv %}
      - direnv {{ version }} is installed for user '{{ user.name }}'
{%-   endfor %}
{%- endfor %}
