module FixnumRefinements
  refine Fixnum do
    # Returns nil if the number is zero
    def nilify!
      zero? ? nil : self
    end
  end
end
