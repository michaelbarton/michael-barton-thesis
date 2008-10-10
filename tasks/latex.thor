require 'fileutils'
require 'find'

class Latex < Thor

  desc "build","builds thesis document"
  method_options :src  => 'src',
                 :dest => 'out',
                 :tmp  => 'tmp'
  def build(file)

    src  = options[:src]
    dest = options[:dest]
    tmp  = options[:tmp]
    log  = 'latex.log'
    

    # Make directories
    FileUtils.makedirs dest unless File.exists?(dest)
    FileUtils.makedirs tmp unless File.exists?(tmp)

    # Copy all files to a temporary directory
    copy_all_files(File.expand_path(src),File.expand_path(tmp))

    error_free = true
    FileUtils.cd(tmp) do
      error_free = system("yes X | latex #{file} > #{log}")
      error_free = system("yes X | bibtex #{file} >> #{log}") if error_free
      error_free = system("yes X | latex #{file} >> #{log}") if error_free
      error_free = system("yes X | latex #{file} >> #{log}") if error_free
    end
    if error_free
      puts "Document built successfully"
    else
      puts "Error building document"
    end
    
  end

  private

  def copy_all_files(src,dest)
    Find.find(src) do |path|
      FileUtils.cp(path,dest) if FileTest.file?(path)
    end
  end

end
