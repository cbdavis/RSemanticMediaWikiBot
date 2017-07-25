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

## Installation
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
R CMD build RSemanticMediaWikiBot
</pre>

3) Install it so that it is accessible within the R environment:
<pre>
sudo R CMD INSTALL RSemanticMediaWikiBot_0.1.tar.gz
</pre>

The functions can then be accessed from within R code by first declaring:
<pre>
library(RSemanticMediaWikiBot)
</pre>

## Basic usage - logging in, reading, editing

### Logging in

<pre>
#TODO fill these in based on your own configuration
username=USERNAME
password=PASSWORD
apiURL = "http://my.wiki.com/wiki/api.php"

bot = initializeBot(apiURL) #initialize the bot
login(username, password, bot) #login to the wiki
</pre>

### Reading page text
<pre>
text = read(title="MyWikiPage", bot) 
</pre>

### Editing and saving page text
<pre>
edit(title="MyWikiPage", 
     text="this is the new page text", 
     bot, 
     summary="my edit summary")
</pre>

### Deleting pages
<pre>
delete(pageName, bot, reason="deleting old page")
</pre>

## Working with template data

### Extracting templates
Assuming that you are not working with multiple instance templates, you can retrieve and modify the data in a template as such:

<pre>
template = getTemplateByName("MyTemplateName", "MyWikiPage", bot)[[1]]
#[[1]] is needed as a list is returned
#If using multiple-instance templates, then multiple templates will be returned
</pre>

### Getting and modifying values of template parameters
<pre>
valueOfTemplate = template$data$NameOfTemplateParameter
</pre>

You can then modify this value by:
<pre>
template$data$NameOfTemplateParameter = newValue
</pre>

### Removing template parameters
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

### Writing the template back to the wiki page
The template with its new value can then be written back to the wiki as such:

<pre>
writeTemplateToPage(template, bot, editSummary="testing bot")
</pre>

The template contains information about the page which it came from, so the name of the page does not need to be specified.

### Writing Spreadsheet Data to Multiple Pages
Spreadsheet data loaded into a dataframe can be used to make it easy to write data to templates contained on multiple pages.  The first column of the data frame specifies the name of the page, while the second column is the name of the template to write to.  The headers for the rest of the columns need to correspond to the names of the parameters in that template.  The default behavior of this code is to not overwrite existing values unless you explicitly tell it to.  A list of pages for which an existing value for a parameter were found are returned.

<pre>
# default - will not overwrite existing parameter values that are already set
errorDFEntries = writeDataFrameToPageTemplates(dataFrame, bot, editSummary="what the bot is doing")

# overwrite existing values
errorDFEntries = writeDataFrameToPageTemplates(dataFrame, bot, overWriteConflicts=TRUE, editSummary="what the bot is doing")
</pre>


### Writing a Data Frame to a Table on a Single page###
The syntax for a sortable wikitable can be generated from a data frame.  The code currently doesn't figure out how to intelligently put it on a page - it's up to you to figure out how to paste things together in some useful way.

<pre>
# get the wiki table syntax
wikiTable = getWikiTableTextForDataFrame(df)

# put some text before and after the table
pageText = paste(someText, "\n\n", wikiTable, "\n\n", someMoreText, sep="")
  
# write this all to some wiki page
edit(title=pageTitle,
     text=pageText,
     bot,
     summary="adding a table")
</pre>

## Future development/known issues
<ul>
<li>No support yet for multiple-instance templates.  There needs to be a way to distinguish if one wants to edit an existing one, or add another.
<li>No support yet for adding a new template to a page.
<li>When editing a page, no check is done to see if it will create the page.
<li>Nested template calls may not be parsed correctly
<li>If the code is not able to connect to the wiki API, then it will terminate instead of trying to connect again.  In practical experience, this means that you may have to run a script multiple times if you have several thousand edits.
<li>There seems to be a memory leak if you read and/or edit around 10,000+ pages.
</ul>
