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
          msg.send "The current weather condition of " +
            "#{obs.display_location.city} is #{obs.weather}:\n" +
            "At #{obs.observation_time_rfc822}, " +
            "Temperature is #{obs.temp_c}°C " +
            "(feels like #{obs.feelslike_c}°C), " +
            "Humidity #{obs.relative_humidity}, " +
            "Pressure #{obs.pressure_mb}hPa, " +
            "Wind #{obs.wind_string}, " +
            "UV #{obs.UV}"

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
