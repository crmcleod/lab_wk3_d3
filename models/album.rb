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

    def save()
        sql = "INSERT INTO albums 
        (
            artist_id,
            title,
            genre
        )
        VALUES
        ($1, $2, $3)
        RETURNING id"
        values = [@artist_id, @title, @genre]
        @id = SqlRunner.run(sql, values)[0]['id'].to_i
    end

    def self.delete_all()
        sql = "DELETE FROM albums"
        SqlRunner.run(sql)
    end

end