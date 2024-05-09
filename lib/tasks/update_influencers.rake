namespace :update_influencers do
  desc "Update scout_status and partner_status values from nil to unknown"
  task update_scout_status_and_partner_status_value: :environment do
    Influencer.where(scout_status: nil).find_each { |influencer| influencer.update(scout_status: 10) }
    Influencer.where(partner_status: nil).find_each { |influencer| influencer.update(partner_status: 10) }

    puts "Update complete: scout_status and partner_status updated."
  rescue StandardError => e
    puts "Error updating scout_status or partner_status: #{e.message}"
  end
end