# Description
#   a hubot weather reporter
#
# Configuration:
#   HUBOT_WEATHER_WUNDERGROUND_KEY
#
# Commands:
#   hubot weather of PLACE <show the weather of a place>
#   hubot what is PLACE exactly called? <find the exact name of a place>
#
# Author:
#   K.K. POON <noopkk@gmail.com>

WUNDERGROUND_KEY = process.env.HUBOT_WEATHER_WUNDERGROUND_KEY

WUNDERGROUND_WEATHER_FORMAT = if process.env.HUBOT_WEATHER_WUNDERGROUND_FORMAT then process.env.HUBOT_WEATHER_WUNDERGROUND_FORMAT else 'c'

WUNDERGROUND_URL = "http://api.wunderground.com/api/#{WUNDERGROUND_KEY}"

module.exports = (robot) ->
  robot.respond /weather of (.*)/i, (msg) ->
    place = msg.match[1]

    msg.http("#{WUNDERGROUND_URL}/conditions/q/#{place}.json")
      .get() (err, res, body) ->
        if err
          msg.send err
          robot.emit 'error', err
          return

        try
          data = JSON.parse(body)
          obs = data.current_observation
          temp = obs.temp_c+'°C'
          feels_like = obs.feelslike_c+'°C'
          if WUNDERGROUND_WEATHER_FORMAT == 'f'
            temp = obs.temp_f+'°F'
            feels_like = obs.feelslike_f+'°F'
           
          msg.send "The current weather condition of " +
            "#{obs.display_location.full} is #{obs.weather}:\n" +
            "#{obs.observation_time}, " +
            "Temperature is #{temp} " +
            "(feels like #{feels_like}), " +
            "Humidity #{obs.relative_humidity}, " +
            "Pressure #{obs.pressure_mb}hPa, " +
            "Wind #{obs.wind_string}, " +
            "UV #{obs.UV}\n" +
            "More information: #{obs.ob_url}"

        catch err
          msg.send err
          robot.emit 'error', err


  robot.respond /what is (.*) (exactly|exact) (called|named|call|name)[\?]?/i, (msg) ->
    place = msg.match[1]

    msg.http("http://autocomplete.wunderground.com/aq?query=#{place}")
      .get() (err, res, body) ->
        if err
          msg.send err
          robot.emit 'error', err
          return

        try
          data = JSON.parse(body)
          results = data.RESULTS
          msg.send "Here are the possibilities:\n" +
            ("- " + r.name for r in results).join "\n"

        catch err
          msg.send err
          robot.emit 'error', err
