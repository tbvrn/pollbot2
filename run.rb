#!/usr/bin/env ruby

require 'capybara'
require 'capybara/poltergeist'

target = "https://whitehouse.typeform.com/to/Jti9QH"

# personal info seeds
first_names = []
last_names = []
zip_codes = []
area_codes = []
email_domains = [
    "gmail",
    "yahoo",
    "msn",
    "hotmail",
    "mail",
]

social_media_css_ids = [
    "div#choice-a66b7eaf-b4c9-4d2a-8fbd-4095e8628d5e",
    "div#choice-b28e40d0-45db-4fbd-a3d4-d3940848ad90",
    "div#choice-7cb83c17-e221-4c6f-af77-97544cb6e3aa",
    "div#choice-0fe0d0a8-e372-42b0-b980-8023da02fd82",
]

desc_1_1 = [
    "I was banned",
    "I got banned",
    "They banned me",
    "I was kicked off the site",
    "I got kicked off the site",
    "They kicked me off the site",
    "I was kicked off the platform",
    "I got kicked off the platform",
    "They kicked me off the platform",
]

desc_1_2 = [
    "My post was deleted",
    "My comment was deleted",
    "My post was taken down",
    "My comment was taken down",
]

desc_2_1 = [
    " because",
    " bc",
    " due to the fact that",
    " cause",
]

desc_2_2 = [
    " for being a",
]

desc_3_1 = [
    " I was a",
    " I was being a",
    " I was acting like a",
]

desc_4_1 = [
    " racist",
    " total",
    " complete",
    " transphobic",
    "n utter",
    " stupid",
    " dumb",
    " drooling",
    " spiteful",
    " screaming",
    " screeching",
    "n ignorant",
]

desc_5_1 = [
    " piece of garbage,",
    " idiot,",
    " moron,",
    " dumbass,",
    " asshole,",
    " piece of shit,",
    " shithead,",
]

desc_6_1 = [
    " just like",
    " like",
    " exactly like",
    " same as",
]

desc_7_1 = [
    " Trump",
    " President Trump",
    " the President",
]

desc_8_1 = [
    "",
    "",
    "",
    "",
    ".",
    ".",
    ".",
    ".",
    ".",
    "!"
]

# load additional info
File.open("area_codes.txt",'r') do |f|
  f.each_line do |line|
    area_codes << line
  end
end
File.open("zip_codes.txt",'r') do |f|
  f.each_line do |line|
    zip_codes << line
  end
end
File.open("first_names.txt",'r') do |f|
  f.each_line do |line|
    first_names << line.chomp.downcase.capitalize
  end
end
File.open("last_names.txt",'r') do |f|
  f.each_line do |line|
    last_names << line.chomp.downcase.capitalize
  end
end

start = Time.now.to_i
successes = 0
failures = 0

session = Capybara::Session.new(:poltergeist, js_errors: false, debug: false)

while true

  begin

    cur_start = Time.now.to_i

    # names
    first = first_names[rand(0...first_names.size)]
    last = last_names[rand(0...last_names.size)]

    session.visit target

    # enter button
    session.click_button("Start")

    # Continue button
    session.click_button("Continue")

    # first name
    node = session.find("input#shortText-bc1c508b-9e1e-42a4-8078-f06127f68674")
    node.set(first)

    # last name
    node = session.find("input#shortText-5f52699a-51e0-4ac0-bcb8-47bd6c296c5e")
    node.set(last)

    # citizenship
    session.find("div#choice-8b713b0a-bd15-4ccd-aeae-af00dfc08788-yes").trigger(:click)

    # age
    session.find("div#choice-1affa7e5-4453-439d-a171-6afda878a7be-yes").trigger(:click)

    # zip code
    node = session.find("input#shortText-43e4b1a1-4201-43cb-a0ed-d46e05f598b8")
    node.set(zip_codes[rand(0...zip_codes.size)])

    # phone
    phone = ""
    case rand(0..3)
      when 0
        phone = "(#{area_codes[rand(0...area_codes.size)]}) #{"%03d" % rand(10**3)}-#{"%04d" % rand(10**4)}"
      when 1
        phone = "#{area_codes[rand(0...area_codes.size)]}-#{"%03d" % rand(10**3)}-#{"%04d" % rand(10**4)}"
      when 2
        phone = "#{area_codes[rand(0...area_codes.size)]} #{"%03d" % rand(10**3)} #{"%04d" % rand(10**4)}"
      when 3
        phone = "#{area_codes[rand(0...area_codes.size)]}#{"%03d" % rand(10**3)}#{"%04d" % rand(10**4)}"
    end
    node = session.find("input#shortText-c388d242-5595-4cba-b232-0cd2b462083b")
    node.set(phone)

    # email
    domain = email_domains[rand(0...email_domains.size)]
    email = ""
    case rand(0..1)
      when 0
        email = "#{first[0]}#{last}#{rand(10**rand(0..8)).to_s(10)}@#{domain}.com".downcase
      when 1
        email = "#{first}#{last[0]}#{rand(10**rand(0..8)).to_s(10)}@#{domain}.com".downcase
    end
    node = session.find("input#email-18890536-dccf-4fcf-9426-2bbfd80dcfaf")
    node.set(email)

    # Continue button
    session
        .find("div.sc-chPdSV.eRpzIt div div div div div div div div button.ButtonWrapper-sc-1g3rldj-0.fViPyO")
        .trigger(:click)

    # social media platform
    session.find(social_media_css_ids[rand(0...social_media_css_ids.size)]).trigger(:click)

    # username
    node = session.find("input#shortText-f7692f6e-6989-4644-ad69-6180b5ed4ff7")
    node.set("#{email.split("@")[0]}#{rand(10**rand(0..8)).to_s(10)}")
    node.send_keys(:enter)

    # description
    desc_1 = ""
    desc_2 = ""
    desc_3 = ""
    case rand(0..1)
      when 0
        desc_1 = desc_1_1[rand(0...desc_1_1.size)]
        case rand(0..1)
          when 0
            desc_2 = desc_2_1[rand(0...desc_2_1.size)]
            desc_3 = desc_3_1[rand(0...desc_3_1.size)]
          when 1
            desc_2 = desc_2_2[rand(0...desc_2_2.size)]
            desc_3 = ""
        end
      when 1
        desc_1 = desc_1_2[rand(0...desc_1_2.size)]
        desc_2 = desc_2_1[rand(0...desc_2_1.size)]
        desc_3 = desc_3_1[rand(0...desc_3_1.size)]
    end
    desc_4 = desc_4_1[rand(0...desc_4_1.size)]
    desc_5 = desc_5_1[rand(0...desc_5_1.size)]
    desc_6 = desc_6_1[rand(0...desc_6_1.size)]
    desc_7 = desc_7_1[rand(0...desc_7_1.size)]
    desc_8 = desc_8_1[rand(0...desc_8_1.size)]
    desc = "#{desc_1}#{desc_2}#{desc_3}#{desc_4}#{desc_5}#{desc_6}#{desc_7}#{desc_8}"
    case rand(0...10)
      when 0
        desc.upcase!
      when 1
        desc.downcase!
      when 2
        desc.downcase!
      when 3
        desc.downcase!
    end

    node = session.find("div.TextAreaWrapper-eos9ho-0.lggbfo textarea")
    node.set(desc)

    # newsletter
    session.find("div#choice-f16b228a-576f-466a-94c8-8dd7e2672e01-no").trigger(:click)

    # bot check
    node = session.find("input#number-a17372a6-a09b-4fec-b39c-16abb0577aeb")
    node.set("1776")

    # terms
    session.find("div#choice-2d2d8db9-857a-46e8-bfa3-e33708b578fe-accept").trigger(:click)

    # stats
    puts "Took #{Time.now.to_i - cur_start} seconds"
    puts desc
    successes += 1
    if successes%10 == 0
      puts "#{successes} successes."
      puts "#{3600*successes/(Time.now.to_i - start).to_f} successes per hour"
    end

  #rescue Capybara::Poltergeist::JavascriptError => x
  rescue
    puts("FAILURE")
    failures += 1
    if failures%10 == 0
      puts "#{failures} failures."
      puts "#{3600*failures/(Time.now.to_i - start).to_f} failures per hour"
    end
    retry
  end

  sleep(1)

end