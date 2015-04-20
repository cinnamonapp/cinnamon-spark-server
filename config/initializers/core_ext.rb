class Range


  # ARITHMETICAL OPERATORS

    # Self times a range or fixnum
    # E.g. (10..20) * 2 = (20..40)
    def *(value)


      range = extract_range_from_value(value)

      # Assume we want to work with int only
      return (self / (1 / value).to_i) if value.kind_of?(Float)

      newfirst  = self.first * range.first
      newlast   = self.last * range.last

      return (newfirst..newlast)
    end

    # Self plus a range or fixnum
    # E.g. (10..20) + (10..20) = (20..40)
    def +(value)
      range = extract_range_from_value(value)

      newfirst  = self.first + range.first
      newlast  = self.last  + range.last

      return (newfirst..newlast)
    end

    # Self divided by a range or fixnum
    # E.g. (10..20) / 2 = (5..10)
    def /(value)
      range = extract_range_from_value(value)

      newfirst = self.first / range.first
      newlast = self.last / range.last

      return (newfirst..newlast)
    end

  # LOGICAL OPERATOR

    def >(range)
      response = false

      if self.last > range.last
        baseline = range.last
        
        deltalast   = self.last - baseline
        deltafirst  = baseline  - self.first
        response = deltalast > deltafirst
      end

      return response
    end

    def <(range)
      response = false

      if self.first < range.first
        baseline = range.first

        deltafirst  = baseline - self.first
        deltalast   = self.last - baseline

        response = deltafirst > deltalast
      end

      return response
    end

    # Returns
    #   1 if self > range
    #   0 if self is_in range
    #   -1 if self < range
    def compare_to(range)
      response = 0

      if self > range
        response = 1
      elsif self < range
        response = -1
      end

      return response
    end

  private
  # Get a Range in any case. Either with a Fixnum or with a Range
  # Used for practical reasons in +,*,/ methods
  def extract_range_from_value(value)
    if value.kind_of?(Fixnum)
      return (value..value)
    elsif value.kind_of?(Float)
      return (value..value)
    elsif value.kind_of?(Range)
      return value
    end
    return nil
  end
end
