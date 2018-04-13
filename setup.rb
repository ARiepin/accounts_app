require 'pg'
require 'yaml'

db_config = YAML::load(File.read('./config/database.yml'))

#create database
begin
  conn = PG.connect(dbname: 'postgres')
  conn.exec("CREATE DATABASE #{db_config['dbname']}")
rescue PG::Error => e
  puts e.message
ensure
  conn.close if conn
end

#connect to database and create tables 'users' and 'accounts'
conn = PG.connect(db_config)
begin
  conn.exec('CREATE EXTENSION IF NOT EXISTS "uuid-ossp";')

  users = conn.exec('CREATE TABLE users(id uuid PRIMARY KEY NOT NULL DEFAULT uuid_generate_v4(),
                                      name VARCHAR(64) NOT NULL,
                                      workflow_state VARCHAR(64) NOT NULL,
                                      sortable_name VARCHAR(64) NOT NULL,
                                      account_id INTEGER)')
  accounts = conn.exec('CREATE TABLE accounts(id INTEGER PRIMARY KEY)')
#create seed data
  conn.exec('INSERT INTO accounts(id) VALUES(7)')
  conn.exec("INSERT INTO users(name, workflow_state, sortable_name, account_id)
             VALUES('John Doe', 'registered', 'john', 7 )")
  conn.exec("INSERT INTO users(name, workflow_state, sortable_name, account_id)
             VALUES('Foo Bar', 'registered', 'foo', 7 )")
rescue PG::Error => e
  puts e.message
ensure
  conn.close if conn
  users.clear if users
  accounts.clear if accounts
end
