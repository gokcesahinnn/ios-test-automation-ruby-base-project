base_page = BasePage.new

Given(/^agree chrome terms$/) do
  base_page.agree_terms
end

And(/^refuse account sync$/) do
  base_page.refuse_account_sync
end