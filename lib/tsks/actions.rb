require "tsks/storage"

module Tsks
  class Actions
    def self.update_tsks_with_uuid uuid
      current_tsks = Tsks::Storage.select_all

      for tsk in current_tsks
        Tsks::Storage.update tsk[:local_id], {user_id: uuid}
      end
    end

    def self.update_server_for_removed_tsks token
      tsks_uuids = Tsks::Storage.select_removed_uuids

      if !tsks_uuids.empty?
        for id in tsks_uuids
          Tsks::Request.delete "/tsks/#{id}", token
        end
      end
    end
  end
end
