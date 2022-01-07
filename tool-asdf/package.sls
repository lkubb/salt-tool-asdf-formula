asdf is installed:
  pkg.installed:
    - name: asdf

asdf setup is completed:
  test.nop:
    - name: asdf setup has finished, hooray.
    - require:
      - asdf is installed
