module Scrobbler
  # Defines some functions that are used nearly all Scrobbler classes which
  # have to deal with the streamable flag.
  #
  # This module defines the class functions, use "extend StreamableClassFuncs" in
  # class.
  module StreamableClassFuncs
    # Check if the given libxml node is defining if the given content is 
    # streamable. If so, set the flag in the given hash
    def Base.maybe_streamable_node(data, node)
      if node.name == 'streamable'
        data[:streamable] = ['1', 'true'].include?(node.content)
      end
    end
    
    # Check if the given libxml node has a streamable attribute defining if the
    # given content is streamable. If so, set the flag in the given hash
    def Base.maybe_streamable_attribute(data, node)
      if node['streamable']
        data[:streamable] = ['1', 'true'].include?(node['streamable'])
      end
    end
    
  end
  
  # Defines some functions that are used nearly all Scrobbler classes which
  # have to deal with the streamable flag.
  #
  # This module defines the object functions, use "include StreamableObjectFuncs" in
  # class.
  module StreamableObjectFuncs
    # Check if the given libxml node is defining if the given content is 
    # streamable. If so, set the flag in the object
    def check_streamable_node(node)
      if node.name == 'streamable'
        @streamable = ['1', 'true'].include?(node.content)
      end
    end
  end
end