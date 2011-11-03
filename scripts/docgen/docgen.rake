# rakefile for docgen related tasks (processing through pandoc)

# paths
tool_path = "~/tools"

# paths to bins
$editor_bin = ENV['EDITOR']
$pandoc_bin = "~/.cabal/bin/pandoc"
$markdown2pdf_bin = "~/.cabal/bin/markdown2pdf"

$xsltproc_bin = "/opt/local/bin/xsltproc"
$fop_bin = "/opt/local/bin/fop"
$jing_bin = "~/.bin/jing"

$convert_bin = "/opt/local/bin/convert"
$pngcrush_bin = "/opt/local/bin/pngcrush"
$advpng_bin = "/opt/local/bin/advpng"

# template and other auxilliary files
$template_tex = tool_path + "/docgen/textemplate.tex"
$css_epub = tool_path + "/docgen/epub.css"

# docbook related
docbook_xsl_prefix = "/opt/local/share/xsl/docbook-xsl"
$docbook_html_xsl = docbook_xsl_prefix + "/html/docbook.xsl"
$docbook_fo_xsl = docbook_xsl_prefix + "/fo/docbook.xsl"

docbook_schema_prefix = "/opt/local/share/xml/docbook/5.0"
$docbook_rng_schema = docbook_schema_prefix + "/rng/docbook.rng"

# set the target variable if it's a valid file
$target = nil
if !ENV["target"].nil? && File.file?(ENV["target"])
    $target = ENV["target"];
end

# default task is to make a pdf
task :default => :pdf

desc "Create pdf, html, and epub files"
multitask :all => [ :pdf, :html, :epub ]

desc "Create a PDF using pandoc's markdown2pdf"
task :pdf do
    if $target
        output_pdf = $target.pathmap("%X.pdf") 
        sh "#{$markdown2pdf_bin}  --xetex -N --template=#{$template_tex} --toc #{$target} -o #{output_pdf}"
    end
end

desc "Create a HTML file with pandoc"
task :html do
    if $target
        output_html = $target.pathmap("%X.html") 
        sh "#{$pandoc_bin} -s -S --toc --css=#{$css_epub} -r markdown #{$target} -w html -o #{output_html}"
    end
end

desc "Create an ePub file with pandoc"
task :epub do 
    if $target
        output_epub = $target.pathmap("%X.epub") 
        sh "#{$pandoc_bin} -S --toc --epub-stylesheet=#{$css_epub} -r markdown #{$target} -w epub -o #{output_epub}"
    end
end

desc "Create a DocBook file with pandoc"
task :docbook do
    if $target
        output_docbook = $target.pathmap("%X.docbook")
        sh "#{$pandoc_bin} -s -S -r markdown #{$target} -w docbook -o #{output_docbook}"
    end
end

desc "Create a html file from docbook"
task :db_html do
    if $target
        output_db_html = $target.pathmap("%X_db.html")
        sh "#{$xsltproc_bin} -o #{output_db_html} #{$docbook_html_xsl} #{$target}"
    end
end

desc "Create a fo and pdf file from docbook"
task :db_fo_pdf do
    if $target
        output_fo = $target.pathmap("%X_db.fo")
        output_pdf = $target.pathmap("%X_db.pdf")
        sh "#{$xsltproc_bin} -o #{output_fo} #{$docbook_fo_xsl} #{$target}"
        sh "#{$fop_bin} #{output_fo} -pdf #{output_pdf}"
    end
end

desc "Check docbook files against schema"
task :db_check do
    if $target
        sh "#{$jing_bin} #{$docbook_rng_schema} #{$target}"
    end
end

desc "Crush PNG files, removing everything but transparency"
task :crush do
    if $target && ( File.extname($target) == ".png" )
        output_crushed = $target.pathmap("%X_crushed.png")
        sh "#{$pngcrush_bin} -q -fix -rem alla #{$target} #{output_crushed}"
        sh "#{$advpng_bin} -q -z --shrink-insane #{output_crushed}"
    end
end

desc "Change dpi on image file to 150"
task :dpi150 do
    if $target 
        setdpi($target, 150)
    end
end

desc "Change dpi on image file to 300"
task :dpi300 do
    if $target 
        setdpi($target, 300)
    end
end

# helper functions
#
def setdpi(file, dpi)
    output_file = file.pathmap("%X_#{dpi}.png")
    sh "#{$convert_bin} -units PixelsPerInch -density #{dpi} #{file} #{output_file}"
end
