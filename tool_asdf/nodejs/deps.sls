# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/nodejs/map.jinja" import dependencies %}

Required packages for compiling NodeJS are available:
  pkg.installed:
    - pkgs: {{ dependencies }}
