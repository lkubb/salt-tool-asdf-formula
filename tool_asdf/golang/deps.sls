# vim: ft=sls

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/golang/map.jinja" import dependencies %}

Required packages for compiling Go are available:
  pkg.installed:
    - pkgs: {{ dependencies }}
