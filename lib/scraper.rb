require 'nokogiri'
require 'open-uri'
require 'pry'

class Scraper
  
  def self.scrape_index_page(index_url)
    html = open(index_url)
    doc = Nokogiri::HTML(html)
    student_info = doc.css(".student-card a")
    student_info.collect do |x|
      {:name => x.css(".student-name").text ,
        :location => x.css(".student-location").text,
        :profile_url =>x.attr('href')
      }
    end
 end

  def self.scrape_profile_page(profile_url)
     html = open(profile_url)
    doc = Nokogiri::HTML(html)
    student_hash = {}

      social = doc.css(".vitals-container .social-icon-container a")
      social.each do |element|
        if element.attr('href').include?("twitter")
          student_hash[:twitter] = element.attr('href')
        elsif element.attr('href').include?("linkedin")
          student_hash[:linkedin] = element.attr('href')
        elsif element.attr('href').include?("github")
          student_hash[:github] = element.attr('href')
        elsif element.attr('href').end_with?("com/")
          student_hash[:blog] = element.attr('href')
        end
      end
      student_hash[:profile_quote] = doc.css(".vitals-container .vitals-text-container .profile-quote").text
      student_hash[:bio] = doc.css(".bio-block.details-block .bio-content.content-holder .description-holder p").text

  student_hash
  end

end

