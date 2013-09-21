# coding: utf-8
module LocationDecorator

  def ownership
    public_p == true ? 'Public' : 'Private'
  end

  def kind
    'Location'
  end
end
