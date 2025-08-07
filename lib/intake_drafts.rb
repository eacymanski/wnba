# frozen_string_literal: true

module IntakeDrafts
  @bad_years = 1997..2015
  @good_years = 2016..2025

  def self.intake(years = @good_years)
    years.each do |year|
      if (draft_data = get_draft_data(year))
        teams_mapping = get_teams_mapping(draft_data)
        draft_data['pageProps']['draftRounds'].each do |round|
          round_number = round['round']
          round['picks'].each do |pick|
            if pick['firstName'].blank? && pick['lastName'].blank?
              puts "missing name data for pick: #{pick}"
            else
              create_pick_data(pick, teams_mapping, year, round_number)
            end
          end
        end
      else
        puts "bad draft page for #{year}"
      end
    end
  end

  private_class_method def self.get_draft_data(year)
    res = Net::HTTP.get_response(URI("https://www.wnba.com/draft/#{year}/board"))
    return unless res.code == '200'

    JSON.parse(Nokogiri::HTML.parse(res.body).at_css('[id="__NEXT_DATA__"]').children[0].to_s)['props']
  end

  private_class_method def self.get_teams_mapping(draft_data)
    draft_data['siteHeaderOptions']['teams'].map { |team| [team['tid'], team['tc']] }.to_h
  end

  private_class_method def self.create_pick_data(pick, teams_mapping, year, round_number)
    player = Player.create!(name: "#{pick['firstName']} #{pick['lastName']}")
    college = pick['college'].blank? ? nil : College.find_or_create_by!(name: pick['college'])
    team = Team.find_by!(location: teams_mapping[pick['teamExternalId'].to_s])
    DraftPick.create!(player: player, college: college, team: team, year: year, round: round_number,
                      pick: pick['pick'], home_country: pick['country'])
  end
end
