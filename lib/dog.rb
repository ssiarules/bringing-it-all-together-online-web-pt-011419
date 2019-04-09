class Dog
  attr_accessor :id, :name, :breed

  def initialize (id:nil, name:, breed:)
    @id = id
    @name = name
    @breed = breed

  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS dogs (
    id INTEGER PRIMARY KEY,
    name TEXT,
    breed TEXT
    );
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = <<-SQL
    DROP TABLE dogs;
    SQL

     DB[:conn].execute(sql)
   end

   def save
   if self.id
     self.update
   else
     sql = <<-SQL
       INSERT INTO dogs (name, breed)
       VALUES (?, ?)
     SQL

     DB[:conn].execute(sql, self.name, self.breed)

     @id = DB[:conn].execute("SELECT last_insert_rowid() FROM dogs")[0][0]
   end
   self
 end

 def self.create(name:, breed:)
   dog = self.new(name:name, breed:breed )
   dog.save
   dog
end

def self.find_by_id(id)
   sql = "SELECT * FROM dogs WHERE id = ? LIMIT 1"
    DB[:conn].execute(sql, id)[1]
   Dog.new(id:[0], name:[1], breed:[2])
 end



end
