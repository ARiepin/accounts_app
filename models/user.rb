require './lib/db_connect'

class User
  class << self
    def find_by_account(account_id)
      users = []
      result = pg_adapter.exec("select id as uuid, name, sortable_name, workflow_state
                                from users
                                where account_id = '#{account_id}'")
      result.map{|row| users << row}
      users
    end

    private

    def pg_adapter
      @pg_adapter ||= DbConnect.new.adapter
    end
  end
end
