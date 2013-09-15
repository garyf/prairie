# coding: utf-8
module PersonDecorator

  def gender
    male_p == true ? 'Male' : 'Female'
  end

  def education_level_name
    education_level ? education_level.name : 'Unspecifed'
  end

  def kind
    'Person'
  end

  def name
    name_last
  end
end
