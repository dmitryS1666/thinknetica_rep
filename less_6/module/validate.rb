module Validate
  def validate!(param, regexp)
    raise 'Text' if param !~ regexp
  end

  def validate?
    true if validate!
    false
  end

end
