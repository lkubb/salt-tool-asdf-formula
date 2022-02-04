{%- from 'tool-asdf/nodejs/map.jinja' import dependencies, pkg_mode -%}

Required packages for compiling NodeJS are available:
  pkg.{{ pkg_mode }}:
    - pkgs: {{ dependencies }}
