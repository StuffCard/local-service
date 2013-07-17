namespace :sync do
  desc "sync slave with master"
  task :start => :environment do |t, args|
    Checkin.unsynced.find_each(batch_size: 10) do |checkin|
      checkin.sync_with_master
    end
  end
end
