module IndeedLib
  module InstanceMethods
    def clear_terminal
      # Try to clear terminal using both methods - Unix (clear) and Windows (cls)
      system "clear" or system "cls"
    end
  end
end