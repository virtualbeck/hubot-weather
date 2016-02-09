# Description: Enter a city to see what the current weather is.
# Author: virtualbeck
# Command:
#   show <city> weather

request = require('request')
options =
  method: 'GET'
  url: 'http://api.openweathermap.org/data/2.5/find'
  qs:
    units: 'imperial'
    appid: '' #visit openweathermap.org to obtain API key

module.exports = (robot) ->
  robot.hear /show ((\S* )*?\S*) weather/i, (msg) ->

    console.log msg.match
    options.qs.q = msg.match[1]

    request options, (error, response, body) ->
      return if error
      jsonBody = JSON.parse body
      console.log jsonBody
      for weatherDetails in jsonBody.list
        if /US|GB|United/i.test weatherDetails.sys.country
          console.log weatherDetails.weather
          myEmoji = switch weatherDetails.weather[0].main
            when 'Clouds' then ':cloud:'
            when 'Snow' then ':snowflake:'
            when 'Clear' then ':sunny:'
            else ':thermometer:'
          msg.send "#{weatherDetails.name} is currently #{weatherDetails.main.temp}°F #{myEmoji}"
