# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    Movie.create!(movie)
  end
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.content  is the entire content of the page as a string.
  #s = "#{e1}.*#{e2}"
  #r = Regexp.new(s)
  ##assert_match(r, page.body)
  #assert page.body.match(r)
  assert page.body.index(e1) < page.body.index(e2)
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  rating_list.split(",").each do |rating|
    rating.strip!
    if uncheck == 'un'
      uncheck "ratings[#{rating}]"
    else
      check "ratings[#{rating}]"
    end
  end
end

Then /I should see movies with ratings: (.*)/ do |rating_list|
  rating_list.split(",").each do |rating|
    rating.strip!
    if page.respond_to? :should
      page.should have_xpath("//td", :text => rating)
    else
      assert page.has_xpath?("//td", :text => rating)
    end
  end
end

Then /I should not see movies with ratings: (.*)/ do |rating_list|
  rating_list.split(",").each do |rating|
    rating.strip!
    if page.respond_to? :should
      page.should have_no_xpath("//td", :text => rating)
    else
      assert page.has_no_xpath?("//td", :text => rating)
    end
  end
end

Then /I should see all the movies/ do
  if page.respond_to? :should
    page.should have_css("tr", :count => 11)
  else
    assert page.has_css?("tr", :count => 11)
  end
end

Then /I should see none of the movies/ do
  if page.respond_to? :should
    page.should have_css("tr", :count => 1)
  else
    assert page.has_css?("tr", :count => 1)
  end
end

