# Description:
#   Script retrieves job listings using authentic jobs api.
#
# Dependencies:
#   None
#
# Configuration:
#   HUBOT_API_AUTH
#
# Commands:
#   eggy find me <title> jobs in <location>
#
# Author:
#   sleekslush, Zain

module.exports = (robot) ->
  robot.respond /find me (.* )?jobs( in (.+))?/i, (msg) ->
    [keywords, location] = [msg.match[1], msg.match[3]]

    params =
      api_key: process.env.HUBOT_API_AUTH
      method: "aj.jobs.search"
      perpage: 10
      format: "json"

    params.keywords = keywords if keywords?
    params.location = location if location?

    msg
      .http("https://authenticjobs.com/api/")
      .query(params)
      .get() (err, res, body) ->
        response = JSON.parse body
        msg.send get_a_job msg, response

get_a_job = (msg, response) ->
  listings = response.listings.listing

  if not listings.length
    return "Sorry, I couldn't find you a job. Guess you're going to be broke for a while!"

  random_listing = msg.random listings

  "#{random_listing.title} at #{random_listing.company.name}. Apply at #{random_listing.url or random_listing.apply_email}"
