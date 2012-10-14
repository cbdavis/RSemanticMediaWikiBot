RSemanticMediaWikiBot
=====================
This is a bot for editing Semantic MediaWiki templates, and is written in R.  This code is very much in development, and it is highly recommended to test it on a few pages before letting it loose on a wiki.

The main idea is that this bot converts templates into data structures in R.  For example, you to read from a wiki page a template such as:
<pre>
{{City
| point=52.015, 4.356667
| country=Netherlands
}}
</pre>

...whose data is then converted into a list within R.  The data contained in the list can be accessed via template$point, template$country, etc.

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
edit(title="MyWikiPage", 
     text="this is the new page text", 
     bot, 
     summary="my edit summary")
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
dataSection = paste(paste(paste("| ", names(wantThisTemplate$data), sep=""), 
                    wantThisTemplate$data, sep="="), 
                    collapse="\n")
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

<h2>Future development/known issues</h2>
<ul>
<li>Need to write a function to make it easier to write data back to the template on the wiki page.
<li>No support yet for multiple-instance templates.  There needs to be a way to distinguish if one wants to edit an existing one, or add another.
<li>No support yet for adding a new template to a page.
<li>When editing a page, no check is done to see if it will create the page.
<li>This code needs to be converted to a proper package for use in R.
</ul>