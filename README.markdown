# Managing Data with Version Control

This repo goes along with a presentation given at [MacTech Conference 2011](http://www.mactech.com/conference/)

![MacTech Conference 2011](/zdw/mtc2011/raw/master/mtc2011_logo.png)

## Notes about my particular process

I create new files in "notes", which are transformed into the XML worklog syntax, which is stored in "worklogs".  This syntax is used to create PDF invoices in "invoice" or ledger files in "ledgers".  I don't include this code because it's pretty ancient, and does some really stupid things (for example, storing unix timestamps in the XML, rather than ISO-8601 dates). 

The rest of the files in the repo were added after the fact (like this README which you are reading right now).

## Scripts 

Note that none of these are fully prepped to work on any system - they often will need other utilities installed, or will need to be fixed to work in your specific environment. These are mainly starting points.

### `scripts/docgen`
  
This is the documentation generation script that I use to convert markdown files into different formats - for example, turning this README into a nicely formatted PDF and HTML docs that are also in the repo.  

It's dependent on pandoc, imagemagick, pdfcrush, advpng and a few other XML specific tools like jing. 

See the `test` subfolder for examples - all the files inside were created from  `testfile.mkd`

### `scripts/mailsend.scpt`

A very simple Applescript that will send an email with specified subject/sender/attachments.  I run this with a bash script that calls rake: 

bash script:

~~~~{.bash .numberlines}
$FOCUSTOOLPATH=~/tools
RAKECMD="rake -f ${FOCUSTOOLPATH}/worklog/worklog.rake"
${RAKECMD} "${1}" target="$2"
~~~~

rakefile: 

~~~~ {.ruby .numberlines}
# set the target variable if it's a valid file
$target = nil
if !ENV["target"].nil? && File.file?(ENV["target"])
    $target = ENV["target"];
end

# mailinvoice
task :mailinvoice => [ :worklogs, :ledgers ] do
    if $target
        note_date = ENV['FOCUSDATE'].gsub('_','-')
        filepath = File.expand_path($target)
        name = customer_name()
        email = customer_email()
        sh "#{$osascript_bin} #{$mailsend_scpt} 'Invoice for #{note_date}' 'Please see the enclosed invoice\n\n' #{name} #{email} #{filepath}"
    end
end
~~~~

## Tools


### Automation Tools 

- [Git](http://git-scm.com/)
    - A version control system
    - Documentation and tutorials
        - [`man gittutorial`](http://schacon.github.com/git/gittutorial.html)
        - [Everyday Git](http://schacon.github.com/git/everyday.html)
        - [Pro Git](http://progit.org/)
        - [Git for Computer Scientists](http://eagain.net/articles/git-for-computer-scientists/)

- [Rake](http://rake.rubyforge.org/)
    - A tool for writing dependency based tasks, in Ruby
    - Tutorials 
        - [Using the Rake Build Language](http://martinfowler.com/articles/rake.html)


### Documentation Tools

- [Markdown](http://daringfireball.net/projects/markdown/)
    - minimalist markup language
    - Multiple implementations, for example [MultiMarkdown](http://fletcherpenney.net/multimarkdown/)
 
- [Pandoc](http://johnmacfarlane.net/pandoc/)
    - Documentation format conversion swiss army knife
    - Will convert Markdown to HTML, ePub, PDF, etc. 

### Accounting Tools

- [Ledger](http://ledger-cli.org/)
    - Ledger is a CLI accounting tool
    - Use the 3.x beta branch off of github, which is being actively developed
