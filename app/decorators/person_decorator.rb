# coding: utf-8
module PersonDecorator

  def gender
    male_p == true ? 'Male' : 'Female'
  end

  def kind
    'Person'
  end

  def name
    name_last
  end
end
