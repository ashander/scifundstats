<!--roptions dev=png,width=5,height=5 -->

A look at #scifund
======

Jaime Ashander
-----

# Linear Models #

Models selected using stepwise AIC (`step`) and most non-collinear terms. 

<!--begin.rcode,echo=FALSE
prj.stats =read.csv('proj.txt')
prj.stats$percent.funded = with(prj.stats, fund_attained/fund_goal)
prj.stats$multiple.contributions = with(prj.stats, total_contributions/unique_contributions)
prj.stats$average.contribution = with(prj.stats, fund_attained/total_contributions)
prj.stats$multiple.contributions.bool = prj.stats$multiple.contributions > 1
end.rcode-->

## percent funded ## 

Initial model
<!--begin.rcode
lm.funded1 = lm(percent.funded~description_length+ total_contributions+ 
  fund_goal+ multiple.contributions+ average.contribution, data = prj.stats)
end.rcode-->

Final model
<!--begin.rcode,echo=FALSE,results=hide
lm.funded = step(lm.funded1)
end.rcode-->

<!--begin.rcode,echo=FALSE
a = summary(lm.funded)
coef(a)
end.rcode-->

## average contribution ## 

Initial model
<!--begin.rcode,echo=FALSE
lm.avgive1 = lm(average.contribution~description_length+
  total_contributions+
  fund_goal+
  multiple.contributions, data = prj.stats)
end.rcode-->

Final model
<!--begin.rcode,echo=FALSE,results=hide
lm.avgive = step(lm.avgive1)
end.rcode-->

<!--begin.rcode,echo=FALSE
b = summary(lm.avgive)
coef(b)
end.rcode-->

## initial conclusions ## 

### percentage funded: ###  

* funding goal negative 
* more contribs better 
* having multiple contribs didn’t help achieve full funding 
* longer description did not help, may slightly hurt 
* higher average contribution did not help

### average contribution: ###

* having multiple contribs per contributor may up the average
contribution, but nothing else seems to help 
* may be driven by a few outliers (see Figure 2)


## future work ## 

* differences by discipline?
* textual analysis
* any way to connect to social network? e.g., quanitify number of friends/followers?


# Figures #

<!--begin.rcode,echo=FALSE
require(ggplot2)
prj.stats$description_length =cut_number(prj.stats$description_length, n=5)
prj.stats$av.contrib.factor = cut_number(prj.stats$average.contribution, n=3)
g = ggplot(prj.stats)
end.rcode-->


Multipanel is split over average contribution (columns) and whether some contributors contributed multiple (rows).

<!--begin.rcode percent-funded,fig=TRUE,message=FALSE
g+theme_bw() + geom_point(aes(fund_goal, percent.funded, size=total_contributions, color=description_length))+ facet_grid(multiple.contributions.bool~av.contrib.factor)+scale_color_brewer(type='seq')
end.rcode-->


<!--begin.rcode average-contribution,fig=TRUE,message=FALSE
g +theme_bw() + geom_point(aes(multiple.contributions, average.contribution, color=description_length, size=fund_goal))+scale_color_brewer(type='seq')
end.rcode-->

# Knitr #

Need to use not only the options below suggested by knitr docs

<!--begin.rcode eval=FALSE
opts_knit$set(theme='gfm', base.url="https://github.com/ashander/scifundstats/raw/master/")
end.rcode-->

but also 

<!--begin.rcode eval=FALSE
opts_knit$set(out.format='gfm')
end.rcode-->


<!--begin.rcode, eval=FALSE,echo=FALSE
#g +theme_bw()+ geom_boxplot(aes(multiple.contributions.bool, average.contribution))+ geom_point(aes(multiple.contributions.bool, average.contribution, color=description_length, size=fund_goal))+scale_color_brewer(type='seq')
end.rcode-->