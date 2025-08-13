# frozen_string_literal: true

module IntakeRosters
  def update_current_rosters
    players = get_player_list_data
    reset_current_teams
    players.each do |player_data|
      player = get_or_create_player(player_data)
      player.update(is_active: true, current_team: Team.find_by(location: team_location(player_data)))
    end
  end

  private_class_method def self.get_player_list_data
    res = Net::HTTP.get_response(URI('https://www.wnba.com/players?team=all&position=all'))
    JSON.parse(Nokogiri::HTML.parse(res.body).at_css('[id="__NEXT_DATA__"]').children[0].to_s)['props']['pageProps']['allPlayersData']
  end

  private_class_method def self.reset_current_teams
    Player.update_all(current_team_id: nil, is_active: false)
  end

  private_class_method def self.get_or_create_player(player_data)
    player = Player.find_by(wnba_id: wnba_id(player_data))
    return player if player

    player = update_player_if_exists(player_data)
    return player if player

    create_player(player_data)
  end

  private_class_method def self.update_player_if_exists(player_data)
    player = Player.find_by(name: name(player_data))
    player.update(wnba_id: wnba_id(player_data), wnba_slug: slug(player_data)) if player
    player
  end

  private_class_method def self.create_player(player_data)
    Player.create(
      name: name(player_data),
      wnba_id: wnba_id(player_data),
      wnba_slug: slug(player_data)
    )
  end

  private_class_method def self.wnba_id(player_data)
    player_data[0]
  end

  private_class_method def self.name(player_data)
    "#{player_data[2]} #{player_data[1]}"
  end

  private_class_method def self.slug(player_data)
    player_data[3]
  end

  private_class_method def self.team_location(player_data)
    player_data[6]
  end
end
