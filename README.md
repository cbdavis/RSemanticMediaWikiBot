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

#get the text on the page
pageTextread(title="MyWikiPage", bot)

#set the text on the page
edit(title="MyWikiPage", text="this is the new page text", bot, summary="this is a very important edit")
</pre>


Assuming that you are not working with multiple instance templates, you can retrieve and modify the data in a template as such:

<pre>
wantThisTemplate = getTemplatesByName("MyTemplate", templateInfo)[[1]]
valueOfTemplate = wantThisTemplate$data$NameOfTemplateParameter
</pre>

You can then modify this value by:
<pre>
wantThisTemplate$data$NameOfTemplateParameter = newValue
</pre>

This template with its new value can then be written back to the wiki as such:

<pre>
header = paste("{{", wantThisTemplate$name, "\n", sep="")
dataSection = paste(paste(paste("| ", names(wantThisTemplate$data), sep=""), wantThisTemplate$data, sep="="), collapse="\n")
footer = "}}"

templateText = paste(header, dataSection, footer, sep="")
  
#now put this back in the main text  
#get text before and after template
textBeforeTemplate = substr(textVal, 1, wantThisTemplate$start-1)
textAfterTemplate = substr(textVal, wantThisTemplate$end+1, 1000000L)
  
#put all the text back together, with the new contents of the template
newPageText = paste(textBeforeTemplate, templateText, textAfterTemplate, sep="")
edit(title=MyWikiPage, text=newPageText, bot, summary="my edit summary")
</pre>