# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Quick Load Node data
ActiveRecord::Base.connection.execute("COPY nodes from '#{Rails.root.join('db','nodes.csv')}' delimiter ',' CSV header")
[
  [2100480,'duck'],
  [2100482,'goose'],
  [2100490,'eagle'],
  [2071178,'swan'], # end of its own chain
].each do |node_id,bird|
  puts node_id
  puts bird
  n = Node.find(node_id)
  b = n.birds.new(node_id: node_id, name: bird)
  b.save
end