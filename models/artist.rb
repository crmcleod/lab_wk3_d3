require ('pg')

require_relative("../db/sql_runner")
require_relative("./album")

class Artist
    attr_reader :id
    attr_accessor :name
    def initialize( options )
        @id = options['id'].to_i if options['id']
        @name = options['name']
    end

    def save()
        sql = "INSERT INTO artists
        (name) VALUES 
        ($1)
        RETURNING * "
        values = [@name]
        returned_array = SqlRunner.run(sql, values)
        artist_hash = returned_array[0]
        id_string = artist_hash['id']
        @id = id_string.to_i
    end

    def update()
        sql = "
        UPDATE artists
        SET
        name = $1
        WHERE id = $2"
        values = [@name, @id]
        SqlRunner.run(sql, values)
    end

    def delete()
        sql = "DELETE FROM artists
        WHERE id = $1"
        values = [@id]
        SqlRunner.run(sql, values)
    end

    def self.all()
        sql = "SELECT * FROM artists"
        artists_hashes = SqlRunner.run(sql)
        artists = artists_hashes.map { |artist| Artist.new(artist)}
        return artists
    end

    def self.delete_all()
        sql = "DELETE FROM artists"
        SqlRunner.run(sql)
    end

    def albums()
        sql = "SELECT * FROM albums WHERE artist_id = $1"
        values = [@id]
        albums = SqlRunner.run(sql, values)
        return albums.map {|album| Album.new(album)}
    end
end