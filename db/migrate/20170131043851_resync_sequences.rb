class ResyncSequences < ActiveRecord::Migration
  def up
    execute('SELECT c.relname FROM pg_class c WHERE c.relkind = \'S\' and c.relname like \'%_id_seq\';').each do |seq|
      table = seq['relname'].gsub(/_id_seq$/, '')
      execute("SELECT setval('#{seq['relname']}', (SELECT MAX(id) FROM #{table})+1);")
    end
  end
end
