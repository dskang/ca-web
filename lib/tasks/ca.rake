namespace :ca do
  desc "Get the breakdown of users in the database by school"
  task school_breakdown: :environment do
    puts School.all.map { |school| "#{school.proper_name}: #{school.users.size}" }
  end

end
