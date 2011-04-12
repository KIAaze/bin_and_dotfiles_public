desc "Insert GPL into all source files"
task :GPL do
  gpl = File.readlines('GPL_header.txt')
  FileList['**/*.cpp'].each do |filename|
    File.open(filename, 'r+') do |file|
      lines = file.readlines      
      # Skip shebang line
      i = (lines[0].index('#!') == 0) ? 1 : 0
      # Already have header?
      next if lines[i].index('/*****') == 0
      
      puts "Liberating #{filename}"
      
      file.pos = 0
      file.print lines.insert(i, gpl).flatten
      file.truncate(file.pos)
    end
  end
  gpl = File.readlines('GPL_header.txt')
  FileList['**/*.h'].each do |filename|
    File.open(filename, 'r+') do |file|
      lines = file.readlines      
      # Skip shebang line
      i = (lines[0].index('#!') == 0) ? 1 : 0
      # Already have header?
      next if lines[i].index('/*****') == 0
      
      puts "Liberating #{filename}"
      
      file.pos = 0
      file.print lines.insert(i, gpl).flatten
      file.truncate(file.pos)
    end
  end
end
