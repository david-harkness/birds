class Bird < ApplicationRecord
  belongs_to :node

  class << self
    def all_child_birds(*ids)
      qry = %|WITH RECURSIVE  path_1 AS (
      select id, parent_id from nodes where id in (?)
      union all
      select  e.id, e.parent_id from nodes e join path_1 on path_1.id = e.parent_id where e.id not in (?)
      ) cycle id  set is_cycle using cycle_path
      select birds.* from path_1, birds where node_id=path_1.id|

      Bird.find_by_sql([qry, *ids, *ids])
    end

  end
end
