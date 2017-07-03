require 'open-uri'
require 'pry'
require 'nokogiri'

class Scraper

  def self.scrape_index_page(index_url)
    #html = open(index_url)
    html = File.read(index_url)
	index = Nokogiri::HTML(html)
	students = []

	index.css(".student-card").each do |student|
		new_student = {}
		new_student[:name] = student.css(".student-name").text
		new_student[:location] = student.css(".student-location").text
		new_student[:profile_url] = student.css("a").attribute("href").value
  		students << new_student
  	end
  	students
  end

  def self.scrape_profile_page(profile_url)
    #html = open(profile_url)
    html = File.read(profile_url)
	profile = Nokogiri::HTML(html)
	profile_info = {}

	profile.css(".social-icon-container a").each do |link|
		if link.attribute("href").value.include?("twitter")
			profile_info[:twitter] = link.attribute("href").value
		elsif link.attribute("href").value.include?("github")
			profile_info[:github] = link.attribute("href").value
		elsif link.attribute("href").value.include?("linkedin")
			profile_info[:linkedin] = link.attribute("href").value
		else 
			profile_info[:blog] = link.attribute("href").value
		end
	end

	profile_info[:profile_quote] = profile.css(".profile-quote").text
	profile_info[:bio] = profile.css(".bio-content p").text
	profile_info
  end

end

