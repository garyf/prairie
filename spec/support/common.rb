# negative test of PostgreSQL constraints
# based on Enterprise Rails, p.55
def expect_db_error(&block)
  begin
    db_error, other_error = 'db_ok', 'other_ok'
    yield
  rescue ActiveRecord::StatementInvalid
    db_error = 'db_error'
  rescue
    other_error = 'other_error'
  end
  expect(other_error).to eql 'other_ok'
  expect(db_error).to eql 'db_error'
end

def svf(obj)
  obj.save(validate: false)
end

STR_35 = '123abcd89_123abcd89_123abcd89_123ab'

STR_56 = '123abcd89_123abcd89_123abcd89_123abcd89_123abcd89_123abc'

EMAIL_255 = '123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.          123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789@a.net'
