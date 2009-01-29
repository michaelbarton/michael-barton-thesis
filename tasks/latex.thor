require 'fileutils'
require 'find'

class Latex < Thor

  desc "build","builds thesis document"
  method_options :src  => 'src',
                 :dest => 'out',
                 :tmp  => 'tmp',
                 :log  => 'log'
  def build(file)

    src  = options[:src]
    dest = options[:dest]
    tmp  = options[:tmp]
    log  = options[:log]

    log_file  = "latex.log"

    # Make directories
    FileUtils.makedirs dest unless File.exists?(dest)
    FileUtils.makedirs tmp unless File.exists?(tmp)
    FileUtils.makedirs log unless File.exists?(log)

    # Copy all files to a temporary directory
    copy_all_files(File.expand_path(src),File.expand_path(tmp))

    error_free = true
    FileUtils.cd(tmp) do
      error_free = system("yes X | latex #{file} > #{log_file}")
      error_free = system("yes X | bibtex #{file} >> #{log_file}") if error_free
      error_free = system("yes X | latex #{file} >> #{log_file}") if error_free
      error_free = system("yes X | latex #{file} >> #{log_file}") if error_free

      error_free = system("dvipdf #{file}.dvi") if error_free
    end
    if error_free
      FileUtils.cp("#{tmp}/#{file}.pdf",dest)
      FileUtils.cp("#{tmp}/#{log_file}",log)
      FileUtils.rm_rf(tmp)
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
