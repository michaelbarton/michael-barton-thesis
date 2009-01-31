require 'fileutils'
require 'find'

class Latex < Thor

  desc "missing", "finds missing citations"
  def missing(log)
    system "grep \"Citation\" #{log} | awk '{print $4}' | sort | uniq"
  end

  desc "headings", "lists the headings in the file"
  def headings(file)
    headings = %x|grep section{ #{file}|
    headings.each do |line|
      pattern = /^\\(.*)section\{([a-zA-Z\s]+)\}/
      level, name = pattern.match(line)[1..2]
      puts "+#{'-' * (level.length/3)} #{name}"
    end
  end

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
      error_free = system("yes X | bibtex #{file} > #{log_file}") if error_free
      error_free = system("yes X | latex #{file} > #{log_file}") if error_free
      error_free = system("yes X | latex #{file} > #{log_file}") if error_free

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
