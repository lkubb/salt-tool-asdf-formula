# vim: ft=sls

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/php/map.jinja" import dependencies %}

Required packages for compiling PHP are available:
  pkg.installed:
    - pkgs: {{ dependencies }}
