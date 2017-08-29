rails_user:
  cmd.run:
    - name: createuser --createdb rails
    - unless: psql -c '\du' | grep rails
    - runas: postgres
gem:
  gem.installed:
    - name: pg
    - user: vagrant
