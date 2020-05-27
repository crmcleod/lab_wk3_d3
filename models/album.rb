require('pg')
require_relative('./artist')
require_relative('../db/sql_runner')

class Album

    attr_reader :id, :artist_id 
    attr_accessor :title, :genre
    
    def initialize(options)
        @title = options['title']
        @genre = options['genre']
        @id = options['id'].to_i if options['id']
        @artist_id = options['artist_id'].to_i
    end

end