module SuperDiff
  module Basic
    module InspectionTreeBuilders
      autoload :Array, "super_diff/basic/inspection_tree_builders/array"
      autoload(
        :CustomObject,
        "super_diff/basic/inspection_tree_builders/custom_object"
      )
      autoload(
        :DataObject,
        "super_diff/basic/inspection_tree_builders/data_object"
      )
      autoload(
        :DefaultObject,
        "super_diff/basic/inspection_tree_builders/default_object"
      )
      autoload :Hash, "super_diff/basic/inspection_tree_builders/hash"
      autoload :Primitive, "super_diff/basic/inspection_tree_builders/primitive"
      autoload :Range, "super_diff/basic/inspection_tree_builders/range"
      autoload :String, "super_diff/basic/inspection_tree_builders/string"
      autoload :TimeLike, "super_diff/basic/inspection_tree_builders/time_like"
      autoload :DateLike, "super_diff/basic/inspection_tree_builders/date_like"
    end
  end
end
