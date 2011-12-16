#!/opt/local/bin/python
'''
grabber [filename] [baseurl] [geturl1] [geturl2] 
scrapes the results lists for project urls from urls comprised of baseurl+geturl1, geturl2,
then pulls down html from all project urls (~49)
'''
import re as r
import sys, urllib2, os

def ProjectStats(html2):
    '''
    accepts list of strings, each string is html from one project web page
    return list of numbers fund_goal fund_attained unique_contributions total_contributions description_length

    (should rewrite to just be strings and file IO bit below would be simpler)
    '''
    # find funds
    funds_html = r.findall("\"box\".*</",html2)
    funds_html1 = [x.replace(",","") for x in funds_html]
    fund_goal, fund_attained = [r.findall("\$[0-9]+", x).pop().replace("$","") for x in funds_html1] #first is goal, second is attained

    # find contribs
    contribs_html = r.findall("\"small-box\".*</",html2)
    unique_contributions, total_contributions = [r.findall("[0-9]+", x).pop() for x in contribs_html] #first is contributors (unique) second is num contributions

    #find length of description
    a = r.search("description-container\">", html2)
    e = r.search("class=\"clear\"", html2)
    description_length = len(html2[a.end():e.start()])
    return [float(fund_goal), float(fund_attained), float(unique_contributions), float(total_contributions), description_length]

archfile = 'archive.dat' # hard-coded archive file
if not os.path.isfile(archfile):
    baseurl = sys.argv[2] #"file://localhost/Users/jaime/code/sandbox/scifund/example.html"#
    geturls = [sys.argv[3],sys.argv[4]]

    html_list = [urllib2.urlopen(baseurl+get).read() for get in geturls]

    result_list = [r.findall("/projects/[0-9]{4}.*\">", html) for html in html_list]
    result_list = [[i.replace("\">", "") for i in result ] for result in result_list]
    [result1, result2 ]= [frozenset(result) for result in result_list] # only working for 2 pages

    projects = result1.union(result2) # unique list of all projects

    project_html = [urllib2.urlopen(baseurl+p_url).read() for p_url in projects]
else:
    archin = open(archfile, 'r')
    project_html = archin.readlines()
    tmp = ''
    tmp = tmp.join(project_html) # project html is a giant string so need to munge into a list for each html page
    project_html = tmp.split("</html>") 
    junk = project_html.pop() # above commands will leave list with one '\n' at end so pop it off

project_stats = [ProjectStats(html) for html in project_html]

file = sys.argv[1]
outfile = open(file,'w')
print>>outfile, 'fund_goal, fund_attained, unique_contributions, total_contributions, description_length'
for item in project_stats:
    item_str = str(item)
    item = item_str[1:(len(item_str)-1)]
    print>>outfile, item
outfile.flush()

if not os.path.isfile(archfile):
    archfile = 'archive.dat'
    archout = open(archfile, 'w')
    for item in project_html:
        print>>archout, item
        outfile.flush()


