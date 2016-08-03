#!/usr/bin ruby

require 'sqlite3'

# Remove SQLite file if it exists.
if File.exists?('blog.sqlite')
  File.delete('blog.sqlite')
end

db = SQLite3::Database.open('blog.sqlite')

# Create table if it doesn't exist.
db.execute <<SQL
  CREATE TABLE posts(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    title VARCHAR(255),
    body TEXT,
    timestamp DATETIME DEFAULT CURRENT_TIMESTAMP
  );
SQL

# Add some dummy posts.
db.execute <<SQL
  INSERT INTO posts (title, body)
  VALUES ('Post number one', 'Lorem ipsum dolor sit bamet...');
SQL

db.execute <<SQL
  INSERT INTO posts(title, body)
  VALUES ('Post number two', 'Lorem ipsum dolor sit bamet...')
SQL