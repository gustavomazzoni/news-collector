require 'test_helper'

class NewsTest < MiniTest::Test
  include AssertEntry

  def test_save
  	# for running multiple times increment bellow
  	count = 1

  	added = News.save("TESTE" + count)
  	assert_equal(true, added)
  	added2 = News.save("TESTE" + count)
  	assert_equal(false, added2)
  end
end