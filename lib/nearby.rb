module Nearby

  RANGE_NEAR_ADD = 15.0
  RANGE_NEAR_PCT = 0.9

  def range_near(value)
    flt = value.to_f
    return (flt - 1.0)..(flt + 1.0) if flt.abs < RANGE_NEAR_ADD
    if flt > 0 
      s = (flt * RANGE_NEAR_PCT).floor
      e = (flt / RANGE_NEAR_PCT).ceil
    else
      s = (flt / RANGE_NEAR_PCT).floor
      e = (flt * RANGE_NEAR_PCT).ceil
    end
    s..e
  end
end
