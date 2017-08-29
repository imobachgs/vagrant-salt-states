postgresql:
  pkg.installed:
    - pkgs:
      - postgresql-server
      - postgresql-devel
  service.running:
    - enable: True
    - require:
      - cmd: pginit
    - watch:
      - file: /var/lib/pgsql/data/pg_hba.conf

pginit:
  cmd.run:
    - name: /usr/bin/initdb --locale=en_US.UTF-8 --auth=ident /var/lib/pgsql/data &> initlog
    - unless: test -d /var/lib/pgsql/data
    - runas: postgres
    - require:
      - pkg: postgresql

/var/lib/pgsql/data/pg_hba.conf:
  file.managed:
    - source: salt://postgresql/pg_hba.conf
    - user: postgres
    - group: postgres
    - mode: 0400
    - require:
      - cmd: pginit
