class Node < ApplicationRecord
  belongs_to :parent, class_name: 'Node', required: false
  has_many :children, class_name: 'Node', foreign_key: :parent_id, dependent: :destroy
  has_many :birds, dependent: :destroy

  scope :top_level, -> { where(parent_id: nil) }

  def all_child_birds
    qry = %|WITH RECURSIVE  path_1 AS (
      select id, parent_id from nodes where id = ?
      union all
      select  e.id, e.parent_id from nodes e join path_1 on path_1.id = e.parent_id
      ) cycle id  set is_cycle using cycle_path
      select birds.* from path_1, birds where node_id=path_1.id|

    Bird.find_by_sql([qry, self.id])
  end

  class << self
    def whole_tree
      tree = []
      top_level.each do |rec|
        tree.push form_tree(rec)
      end
      tree
    end

    def find_depth(lca_id)
      qry = %|
      WITH RECURSIVE
      path_1 AS (
                  select 1 as depth,id, parent_id from nodes where id = ?
      union all
      select depth + 1, e.id, e.parent_id from nodes e join path_1 on e.id = path_1.parent_id
      ) cycle id  set is_cycle using cycle_path

      select max(depth) as depth_lca from path_1 |
      Node.find_by_sql([qry, lca_id]).first&.depth_lca
    end

    def format_answer(id_1, id_2)
      answers = get_common_ancestors(id_1, id_2)
      if answers.nil? || answers.any? { |ans| ans.is_cycle }
        return { root_id: nil, lowest_common_ancestor: nil, depth: nil }
      end

      lca = answers.first
      root = answers.last
      { root_id: root&.id, lowest_common_ancestor: lca&.id, depth: find_depth(lca&.id) }
    end

    # Get path of both node. Include nodes common to both
    # Order is in greatest common ancestor down to root
    def get_common_ancestors(id_1, id_2)
      qry = %| WITH RECURSIVE
        #{get_recursion('path_1')},
        #{get_recursion('path_2')}
        select id, is_cycle from path_1 where id in (select id from path_2)|
      Node.find_by_sql([qry, id_1, id_2])
    end

    private

    def get_recursion(letter)
      %|#{letter} AS (
        select id, parent_id from nodes where id = ?
        union all
        select  e.id, e.parent_id from nodes e join #{letter} on e.id = #{letter}.parent_id
        ) cycle id  set is_cycle using cycle_path
      |
    end

    # => {1045177=>[{1045178=>[{1045200=>[{2138651=>[2138692]}]}]}, 4781951]}
    def form_tree(rec = nil)
      return nil if rec.nil?
      return nil unless rec.class == Node
      return { name: rec.id } if rec.children.empty?

      h = {}
      rec.children.each do |child|
        h[rec.id] ||= []
        h[rec.id].push(form_tree(child))
      end
      { name: rec.id, children: h[rec.id] }
    end

  end
end
