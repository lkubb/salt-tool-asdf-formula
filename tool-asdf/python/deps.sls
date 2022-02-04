{%- from 'tool-asdf/python/map.jinja' import dependencies, pkg_mode -%}

Required packages for compiling Python are available:
  pkg.{{ pkg_mode }}:
    - pkgs: {{ dependencies }}
