RSemanticMediaWikiBot
=====================
Bot for editing Semantic MediaWiki templates, written in R.

<pre>
setwd("/dir/to/this/code")
source("bot.R") 

#TODO fill these in based on your own configuration
username=USERNAME
password=PASSWORD
apiURL = "http://my.wiki.com/wiki/api.php"

#initialize the bot
bot = initializeBot(apiURL)
#login to the wiki
login(username, password, bot)
read(title="MyWikiPage", bot)
edit(title="MyWikiPage", text="this is the new page text", bot, summary="this is a very important edit")
</pre>