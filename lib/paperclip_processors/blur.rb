module Paperclip

  class Blur < Processor

    def initialize file, options = {}, attachment = nil
      super
      @format = File.extname(@file.path)
      @basename = File.basename(@file.path, @format)
    end

     def make
       src = @file
       dst = Tempfile.new([@basename, @format])
       dst.binmode

       begin
         parameters = []
         parameters << ":source"
         parameters << "-blur 0x8"
         parameters << "-modulate 80,47"
         parameters << "-sigmoidal-contrast 1x0"
         parameters << ":dest"

         parameters = parameters.flatten.compact.join(" ").strip.squeeze(" ")

         success = Paperclip.run("convert", parameters, :source => "#{File.expand_path(src.path)}[0]", :dest => File.expand_path(dst.path))
       rescue PaperclipCommandLineError => e
         raise PaperclipError, "There was an error during the blur conversion for #{@basename}" if @whiny
       end

       dst
     end

  end
end
