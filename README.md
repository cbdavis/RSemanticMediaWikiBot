RSemanticMediaWikiBot
=====================
This is a bot for editing Semantic MediaWiki templates, and is written in R.  This code is very much in development, and it is highly recommended to test it on a few pages before letting it loose on a wiki.

The main idea is that this bot converts templates into data structures in R.  For example, it allows you to read from a wiki page a template such as:
<pre>
{{City
| point=52.015, 4.356667
| country=Netherlands
}}
</pre>

...and then convert this data into a list within R.  The data contained in the list can be accessed via template$point, template$country, etc.

<h2>Basic usage - logging in, reading, editing</h2>

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

<h2>Working with template data</h2>

Assuming that you are not working with multiple instance templates, you can retrieve and modify the data in a template as such:

<pre>
template = getTemplateByName("MyTemplateName", "MyWikiPage", bot)[[1]]
#[[1]] is needed as a list is returned
#If using multiple-instance templates, then multiple templates will be returned

valueOfTemplate = template$data$NameOfTemplateParameter
</pre>

You can then modify this value by:
<pre>
template$data$NameOfTemplateParameter = newValue
</pre>


If you want to completely remove a parameter from a template (i.e. both the key and the value) such as changing this:
<pre>
{{City
| point=52.015, 4.356667
| country=Netherlands
}}
</pre>
to this:
<pre>
{{City
| point=52.015, 4.356667
| country=Netherlands
}}
</pre>
then you can just do:
<pre>
template$data$point = NULL
</pre>


The template with its new value can then be written back to the wiki as such:

<pre>
writeTemplateToPage(template, bot, editSummary="testing bot")
</pre>

The template contains information about the page which it came from, so the name of the page does not need to be specified.

<h2>Future development/known issues</h2>
<ul>
<li>Need to implement CSV to wiki pages functionality.  Two columns will specify the page and template names, while the rest of the columns specify the values for parameters in that template.
<li>No support yet for multiple-instance templates.  There needs to be a way to distinguish if one wants to edit an existing one, or add another.
<li>No support yet for adding a new template to a page.
<li>When editing a page, no check is done to see if it will create the page.
<li>This code needs to be converted to a proper package for use in R.
<li>Nested template calls may not be parsed correctly
</ul>