namespace :import do
  desc "Import athletes from Kaggle CSV file (athlete_information.csv format)"
  task :athletes, [ :path ] => :environment do |_t, args|
    abort "Usage: rake import:athletes[path/to/file.csv]" unless args[:path]
    abort "File not found: #{args[:path]}" unless File.exist?(args[:path])

    puts "Importing athletes from #{args[:path]}..."
    CsvImporter::AthleteImporter.import(args[:path])
    puts "Done. Total athletes: #{Athlete.count}"
  end

  desc "Import results from Kaggle CSV file (athlete_results.csv format)"
  task :results, [ :path ] => :environment do |_t, args|
    abort "Usage: rake import:results[path/to/file.csv]" unless args[:path]
    abort "File not found: #{args[:path]}" unless File.exist?(args[:path])

    puts "Importing results from #{args[:path]}..."
    CsvImporter::ResultImporter.import(args[:path])
    puts "Done. Total results: #{RoundResult.count}"
  end

  desc "Import athletes then results from Kaggle CSV files"
  task :all, [ :athletes_path, :results_path ] => :environment do |_t, args|
    abort "Usage: rake import:all[athletes.csv,results.csv]" unless args[:athletes_path] && args[:results_path]
    abort "Athletes file not found: #{args[:athletes_path]}" unless File.exist?(args[:athletes_path])
    abort "Results file not found: #{args[:results_path]}" unless File.exist?(args[:results_path])

    Rake::Task["import:athletes"].invoke(args[:athletes_path])
    Rake::Task["import:results"].invoke(args[:results_path])
  end
end
