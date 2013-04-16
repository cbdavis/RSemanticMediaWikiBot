RSemanticMediaWikiBot
=====================
This is an bot developed in R for editing Semantic MediaWiki templates.  This code is very much in development, and it is highly recommended to test it on a few pages before letting it loose on a wiki.

The primary motivation for <a href="http://en.wikipedia.org/wiki/Wikipedia:Creating_a_bot#Programming_languages_and_libraries">Yet Another MediaWiki Bot Framework</a> is that this bot is specifically design to help with batch editing of data contained within <a href="http://semantic-mediawiki.org/wiki/Help:Semantic_templates">Semantic Templates</a> that are commonly used with <a href="http://semantic-mediawiki.org/">Semantic MediaWiki</a>.

The main idea is that this bot converts templates into data structures in R.  For example, it allows you to read from a wiki page a template such as:
<pre>
{{City
| point=52.015, 4.356667
| country=Netherlands
}}
</pre>

...and then convert this data into a list within R.  The data contained in the list can be accessed via template$point, template$country, etc.

<h2>Installation</h2>
Once you check out the code, you can install the package via:
<pre>
cd Directory/Of/RSemanticMediaWikiBot
bash ./checkBuildAndInstall.sh
</pre>

This runs a shell script which performs the steps below:

1) Check that everything is ok:
<pre>
cd Directory/Of/RSemanticMediaWikiBot
R CMD check .
</pre>

2) Build:
<pre>
cd .. 
R CMD build cd Directory/Of/RSemanticMediaWikiBot
</pre>

3) Install it so that it is accessible within the R environment:
<pre>
sudo R CMD INSTALL cd Directory/Of/RSemanticMediaWikiBot_0.1.tar.gz
</pre>

The functions can then be accessed from within R code by first declaring:
<pre>
library(cd Directory/Of/RSemanticMediaWikiBot)
</pre>

<h2>Basic usage - logging in, reading, editing</h2>

<h3>Logging in</h3>

<pre>
#TODO fill these in based on your own configuration
username=USERNAME
password=PASSWORD
apiURL = "http://my.wiki.com/wiki/api.php"

bot = initializeBot(apiURL) #initialize the bot
login(username, password, bot) #login to the wiki
</pre>

<h3>Reading page text</h3>
<pre>
text = pageTextread(title="MyWikiPage", bot) 
</pre>

<h3>Editing and saving page text</h3>
<pre>
edit(title="MyWikiPage", 
     text="this is the new page text", 
     bot, 
     summary="my edit summary")
</pre>

<h3>Deleting pages</h3>
<pre>
delete(pageName, bot, reason="deleting old page")
</pre>

<h2>Working with template data</h2>

<h3>Extracting templates</h3>
Assuming that you are not working with multiple instance templates, you can retrieve and modify the data in a template as such:

<pre>
template = getTemplateByName("MyTemplateName", "MyWikiPage", bot)[[1]]
#[[1]] is needed as a list is returned
#If using multiple-instance templates, then multiple templates will be returned
</pre>

<h3>Getting and modifying values of template parameters</h3>
<pre>
valueOfTemplate = template$data$NameOfTemplateParameter
</pre>

You can then modify this value by:
<pre>
template$data$NameOfTemplateParameter = newValue
</pre>

<h3>Removing template parameters</h3>
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
| country=Netherlands
}}
</pre>
then you can just do:
<pre>
template$data$point = NULL
</pre>

<h3>Writing the template back to the wiki page</h3>
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
<li>If the code is not able to connect to the wiki API, then it will terminate instead of trying to connect again.  In practical experience, this means that you may have to run a script multiple times if you have several thousand edits.
<li>There seems to be a memory leak if you read and/or edit around 10,000+ pages.
</ul>
