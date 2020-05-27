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

    def update()
        sql = "
        UPDATE albums
        SET
        (
        artist_id,
        title,
        genre
        ) = 
        ($1, $2, $3)
        WHERE id = $4"
        values = [@artist_id, @title, @genre, @id]
        SqlRunner.run(sql, values)
    end

    def delete()
        sql = "DELETE FROM albums
        WHERE id = $1"
        values = [@id]
        SqlRunner.run(sql, values)
    end

    def self.find(id)
        sql = "SELECT *
        FROM albums
        WHERE id = $1"
        values = [id]
        result = SqlRunner.run(sql, values)
        album_hash = result.first
        album = Album.new(album_hash)
        return album
    end

    def self.all
        sql = "SELECT * FROM albums"
        album_hashes = SqlRunner.run(sql) 
        albums = album_hashes.map {|album| Album.new(album)}
        return albums
    end

    def self.delete_all()
        sql = "DELETE FROM albums"
        SqlRunner.run(sql)
    end


    def artist
        sql = 'SELECT * FROM artists WHERE id = $1'
        values = [@artist_id]
        artist = SqlRunner.run(sql, values)[0]
        return Artist.new(artist)

    end

end