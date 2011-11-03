# Managing Data with Version Control

This repo goes along with a presentation given at [MacTech Conference 2011](http://www.mactech.com/conference/)

![MacTech Conference 2011](/zdw/mtc2011/raw/master/mtc2011_logo.png)

## Notes about my particular process

I create new files in "notes", which are transformed into the XML worklog syntax, which is stored in "worklogs".  This syntax is used to create PDF invoices in "invoices" or ledger files in "ledgers".  

I don't include the worklog parsing/ledger/pdf generation code itself because it's pretty ancient, in PHP, has a bunch of weird non-current library dependencies and does some really stupid things (for example, storing unix timestamps in the XML, rather than ISO-8601 dates). 

The rest of the files in the repo were added after the fact (like this README which you are reading right now).

## Tools

### Automation Tools 

- [Git](http://git-scm.com/)
    - Documentation and tutorials
        - [`man gittutorial`](http://schacon.github.com/git/gittutorial.html)
        - [Everyday Git](http://schacon.github.com/git/everyday.html)
        - [Pro Git](http://progit.org/)
        - [Git for Computer Scientists](http://eagain.net/articles/git-for-computer-scientists/)

- [Mercurial](http://mercurial.selenic.com/)
    - Documentation and tutorials
        - [Hg Init](http://hginit.com/)
        - [Mercurial: The Definitive Guide](http://hgbook.red-bean.com/)

- [Rake](http://rake.rubyforge.org/)
    - A tool for writing dependency based tasks, in Ruby
    - Tutorials 
        - [Using the Rake Build Language](http://martinfowler.com/articles/rake.html)
        - [Using Rake to Automate Tasks](http://www.stuartellis.eu/articles/rake/)


### Documentation Tools

- [Markdown](http://daringfireball.net/projects/markdown/)
    - minimal markup language, widely implemented
    - One example: [MultiMarkdown](http://fletcherpenney.net/multimarkdown/)
 
- [Pandoc](http://johnmacfarlane.net/pandoc/)
    - Documentation format conversion swiss army knife
    - Will convert Markdown to HTML, ePub, PDF, etc. 

### Accounting Tools

- [Ledger](http://ledger-cli.org/)
    - Ledger is a CLI accounting tool
    - Multiple implementations
        - the original C++ version, given above
        - [Beancount](http://furius.ca/beancount/) in python
        - [hledger](http://hledger.org/) in haskell
    - The 3.x beta branch off of github is preferred over the older 2.6.x version in MacPorts


## Scripts 

Note that these are pulled straight from my code, and won't work without fairly serious modifications - they often will need other utilities installed. Use this as a starting point

### `scripts/docgen`
  
This is the documentation generation script that I use to convert markdown files into different formats - for example, turning this README into a nicely formatted PDF and HTML docs that are also in the repo.  

It's dependent on pandoc, imagemagick, pdfcrush, advpng and a few other XML specific tools like jing. 

See the `test` subfolder for examples - all the files inside were created from  `testfile.mkd`

### `scripts/mailsend.scpt`

A very simple Applescript that will send an email with specified subject/sender/attachments.  I run this with a bash script that calls rake.

*bash script:*

~~~~{.bash .numberlines}
RAKECMD="rake -f ~/tools/worklog.rake"
${RAKECMD} "${1}" target="$2"
~~~~

*rakefile:*

~~~~ {.ruby .numberlines}
# set the target variable if it's a valid file
$target = nil
if !ENV["target"].nil? && File.file?(ENV["target"])
    $target = ENV["target"];
end

# mailinvoice
desc "Create an email message with attachment in Mail.app" 
task :mailinvoice => [ :worklogs, :ledgers ] do
    if $target
        note_date = `date +"%Y-%m-%d"`
        filepath = File.expand_path($target)
        name = customer_name()
        email = customer_email()
        sh "#{$osascript_bin} #{$mailsend_scpt} 'Invoice for #{note_date}' 'Please see the enclosed invoice\n\n' #{name} #{email} #{filepath}"
    end
end
~~~~
