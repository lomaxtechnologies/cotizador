class CreateTmp
    def initialize(params)
        @src_file = params[:src]
        @name = params[:name]
        @ext = params[:ext]
    end

    def create
        file = Tempfile.new([@name,@ext],"#{Rails.root.to_s}/tmp/")
        file.binmode
        open(@src_file) { |f| file.write(@src_file.read) }
        file.rewind
        file.close
        return file
    end
end