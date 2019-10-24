# frozen_string_literal: true

namespace :quotation do
  desc 'TODO'
  task check_state: :environment do
    Quotation.ransack(
      created_at_lteq: 15.days.ago,
      state_in: [0, 1]
    ).result.each(&:expired!)
  end
end
