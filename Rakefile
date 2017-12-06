require 'rubygems'
require 'zip/zip'
require 'rubygems/package_task'

version = "1.0.2"

spec = Gem::Specification.new do |s|
  s.name        = 'BusinessPlatformSDK'
  s.version     = version
  s.date        = '2016-09-26'
  s.summary     = "An sms-client for the websms-api-platform!"
  s.description = "An sms-client for the websms-api-platform. Evaluates, processes and sends an sms-message-request."
  s.authors     = ["Sebastian Wilhelm"]
  s.email       = 'developer@websms.com'
  s.files       = FileList['lib/BusinessPlatformSDK.rb','lib/BusinessPlatformSDK/*.rb'].to_a
  s.homepage    = 'http://api.websms.com'
  s.extra_rdoc_files = ['README.rdoc']
  s.has_rdoc = true
  s.add_dependency('json_pure', '>= 1.7.5')
end

Gem::PackageTask.new(spec) do |pkg|

 
  pkg.need_zip = true
  #pkg.zip_command = '"C:\Program Files\7-Zip\7z.exe" a -tzip'

end

zip_file_name = "RUBY_SMS_Toolkit-" + version + ".zip"

 if(File.exists?(zip_file_name))
   File.delete(zip_file_name)
   puts "Old zip file deleted."
 end
 
 # Problems with Zip? CALL "rake gem" and pack those 2 files gem file and README.md to a zip by yourself
 
task :package => [:gem] do
readme_file = File.open('README.md', 'r')
gem_name = "#{spec.name}-#{spec.version}.gem"
gem_file = File.open("pkg/"+gem_name, 'r')



Zip::ZipFile.open(zip_file_name, Zip::ZipFile::CREATE) {
  |zipfile|
  
  zipfile.mkdir(zip_file_name)
  zipfile.add(zip_file_name+"/README.md",readme_file.path)
  zipfile.add(zip_file_name+"/"+gem_name,"pkg/"+gem_name)
}
puts "Build succeeded."
end